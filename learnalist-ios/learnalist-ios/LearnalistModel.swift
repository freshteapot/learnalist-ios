
import SQLite
import SwiftyJSON


class LearnalistModel {
    var db: Connection!
    var dbPath: String!

    init() {
        // We are only setting everything up, so no need to care for the response.
        _ = getDb()
    }

    private func getPath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!

        let _dbPath = "\(path)/db.sqlite3"
        return _dbPath
    }

    private func getDb() -> Connection {
        if db != nil {
            print("Returning db already opened.")
            return db
        }


        dbPath = getPath()
        let fileManger = FileManager.default
        let dbExists = fileManger.fileExists(atPath: dbPath);

        print("Db exists: \(dbExists)")
        print("Creating and opening db at: \(dbPath)")

        do {
            db = try Connection(dbPath)
        } catch {
            print("Failed to get the db: \(dbPath).")
            print("error: \(error).")
        }


        setup()

        // dbExists
        return db
    }

    func reset() {
        let fileManger = FileManager.default

        do {
            try fileManger.removeItem(atPath: dbPath)
        } catch {
            print("Removing the old db, error: \(error).")
        }
    }

    func setup() {
        print("Setup db.")

        func setupTable(name: String, sql: String) {
            do {
                try db.execute(sql)

                var stmt = try db.prepare("SELECT name FROM sqlite_master WHERE type = 'table'")
                var schema = try stmt.scalar() as! String
                print(schema)

                stmt = try db.prepare("SELECT sql FROM sqlite_master WHERE name=?;")
                schema = try stmt.scalar(name) as! String
                print(schema)
            } catch{
                // print("error: \(error).")
            }
        }

        setupTable(
            name: "settings",
            sql: "create table settings (username CHARACTER(36) not null primary key, data text);"
        )

        setupTable(
            name: "alist_kv",
            sql: "create table alist_kv (uuid CHARACTER(36)  not null primary key, list_type CHARACTER(3), body text, user_uuid CHARACTER(36));"
        )

        setupTable(
            name: "alist_kv_server_to_local",
            sql: "create table alist_kv_server_to_local (uuid CHARACTER(36)  not null primary key, from_uuid CHARACTER(36));"
        )
    }


    func saveSettings(settings: SettingsInfo) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(settings.username, forKey: "lal.username")
        userDefaults.set(settings.password, forKey: "lal.password")
    }

    static func getUUID() -> String {
        let uuid = UUID().uuidString.lowercased()
        return uuid
    }

    func getSettings() -> SettingsInfo {
        let userDefaults = UserDefaults.standard
        var username = ""
        var password = ""
        var server = ""
        username  = userDefaults.string(forKey: "lal.username")!
        password  = userDefaults.string(forKey: "lal.password")!
        server  = userDefaults.string(forKey: "lal.server")!

        let settingsInfo = SettingsInfo(
            username:username,
            password: password,
            server: server)
        return settingsInfo
    }

    // Delete all lists for the logged in user.
    func deleteAllLists() {
        do {
            try self.db.execute("DELETE FROM alist_kv;")
        } catch {

        }

        let api = LearnalistApi(settings: self.getSettings())

        api.onResponse.subscribe(on: self) { response in
            if response.response?.statusCode == 200 {
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)

                    for (_, aList):(String, JSON) in json {
                        let apiClean = LearnalistApi(settings: self.getSettings())
                        apiClean.deleteList(aList["uuid"].string!)
                        //@todo Remove from the db
                    }
                }

            }
        }
        api.getMyLists()
    }

    func getMyLists() -> [AlistSummary] {
        var items = [AlistSummary]()
        do {
            // This has no context of lists that are not mine.
            let stmt = try db.prepare("SELECT uuid, list_type, body FROM alist_kv")
            for row in try stmt.run() {
                let uuid = row[0] as! String
                let listType = row[1] as! String
                let body = row[2] as! String
                if let dataFromString = body.data(using: .utf8, allowLossyConversion: false) {

                    let json = JSON(data: dataFromString)
                    let listTypeFromBody = json["info"]["type"].string!
                    let uuidFromBody = json["uuid"].string!
                    let title = json["info"]["title"].string!

                    assert(uuid == uuidFromBody, "Uuid do not match in row with uuid: \(uuid)")
                    assert(listType == listTypeFromBody, "Type do not match in row with type: \(listType)")

                    items.append(AlistSummary(
                        uuid: uuid,
                        listType: listType,
                        title: title
                    ))
                }
            }
        } catch {
            print("Doh")
        }
        return items
    }

    func getListByFrom(_ uuid:String) -> Any {
        var aList:Any!
        do {
            let stmt = try db.prepare("SELECT uuid FROM alist_kv_server_to_local WHERE from_uuid=?")
            let from = try stmt.scalar(uuid) as! String
            aList = getListByUuid(from)
        } catch {
            aList = nil
        }
        return aList
    }

    func getListByUuid(_ uuid:String) -> Any {
        var aList:Any!
        do {
            // This has no context of lists that are not mine.
            let stmt = try db.prepare("SELECT body FROM alist_kv WHERE uuid=?")
            let jsonString = try stmt.scalar(uuid) as? String
            if jsonString == nil {
                return getListByFrom(uuid)
            }

            aList = AlistV1(json: JSONParseToDictionary(text: jsonString!)!)

        } catch {
            aList = nil
        }
        return aList
    }

    // Might need to think this thru a little
    func saveList(_ aList: AlistV1) {
        self.saveList(uuid: aList.uuid, info: aList.info, body: JSONStringify(aList.toJSON()!, pretty:false))
    }

    func saveList(_ aList: AlistV2) {
        self.saveList(uuid: aList.uuid, info: aList.info, body: JSONStringify(aList.toJSON()!, pretty:false))
    }

    // I wonder if I should pass in SwiftyJSON.JSON	so I can maniuplate the data
    private func saveList(uuid: String, info: AlistInfo, body: String) {
        let api = LearnalistApi(settings: getSettings())

        if (info.from != nil) {
            // Write to the local database first
            self.insertAlist(uuid: info.from!, listType: info.listType, body: body)
            // Send to the server
            api.postList(listType: info.listType, body: body)
            api.onResponse.subscribe(on: self) { response in
                if response.response?.statusCode == 200 {
                    // Update the local database with the uuid from the server.
                    if let jsonObject = response.result.value {
                        var json = JSON(jsonObject)
                        let uuid = json["uuid"].string!
                        let from = json["info"]["from"].string!
                        let listType = json["info"]["type"].string!
                        // Now that we have the real uuid from the server, we can remove the one in from.
                        json["info"].dictionaryObject!.removeValue(forKey: "from")
                        self.updateList(uuid:uuid, from:from, listType:listType, body:json.rawString(options:JSONSerialization.WritingOptions())!)
                    }
                }
            }
            return
        }
        // This is an update where the uuid we are using is in sync with the server.
        self.updateList(uuid:uuid, from: nil, listType:info.listType, body:body)
        api.putList(uuid: uuid,listType: info.listType, body: body)
        api.onResponse.subscribe(on: self) { response in
            if response.response?.statusCode != 200 {
                // @todo warn sync?
                print("Failed to update the server for some reason.")
                return
            }
            print("List has been updated.")
        }
    }

    func updateList(uuid: String, from: String?, listType: String, body: String) {
        if from != nil {
            // This is most likely coming via the server as we are swapping "local" uuid for "remote" uuid.
            do {
                let stmt = try db.prepare("UPDATE alist_kv SET uuid=?, list_type=?, body=? WHERE uuid=?")
                try stmt.run(uuid, listType, body, from)

                let stmtServerToLocal = try db.prepare("INSERT INTO alist_kv_server_to_local(uuid, from_uuid) VALUES(?,?)")
                try stmtServerToLocal.run(uuid, from)
            } catch {
                print("Failed to save: \(error)")
                if case SQLite.Result.error(let message, let code, _) = error {
                    print(code)
                    print(message)
                    if code == SQLITE_CONSTRAINT {
                        print("Unique shit")
                    }
                }
            }
        } else {
            do {
                let stmt = try db.prepare("UPDATE alist_kv SET list_type=?, body=? WHERE uuid=?")
                try stmt.run(listType, body, uuid)
            } catch {
                print("Failed to save: \(error)")
                if case SQLite.Result.error(let message, let code, _) = error {
                    print(code)
                    print(message)
                    if code == SQLITE_CONSTRAINT {
                        print("Unique shit")
                    }
                }
            }
        }
    }

    func insertAlist(uuid: String, listType: String, body: String) {
        if listType == "v1" {
            do {
                print("Saving to database")
                let stmt = try db.prepare("INSERT INTO alist_kv(uuid, list_type, body) values(?,?,?)")
                try stmt.run(uuid, listType, body)
            } catch {
                print("Failed to save: \(error)")
                if case SQLite.Result.error(let message, let code, _) = error {
                    print(code)
                    print(message)
                    if code == SQLITE_CONSTRAINT {
                        print("Unique shit")
                    }
                }
            }
        } else {
            print("@todo insert listType \(listType)")
        }
    }

    func clearAlistServerToLocalMapping() {
        do {
            try self.db.execute("DELETE FROM alist_kv_server_to_local;")
        } catch {

        }
    }

    func resetBasedOnServer() {
        do {
            try self.db.execute("DELETE FROM alist_kv;")
        } catch {
            return
        }

        let api = LearnalistApi(settings: self.getSettings())
        api.onResponse.subscribe(on: self) { response in
            if response.response?.statusCode == 200 {
                if let jsonObject = response.result.value {
                    let json = JSON(jsonObject)
                    for (_, aList):(String, JSON) in json {
                        // Check to see if it is in the database?
                        if aList["info"]["type"].string! == "v1" {
                            if let test = AlistV1(json: JSONParseToDictionary(text: aList.rawString()!)!) {
                                self.insertAlist(uuid: test.uuid, listType: test.info.listType, body:aList.rawString()!)
                            }
                        } else if aList["info"]["type"].string! == "v2" {
                            if let test = AlistV2(json: JSONParseToDictionary(text: aList.rawString()!)!) {
                                self.insertAlist(uuid: test.uuid, listType: test.info.listType, body:aList.rawString()!)                            }
                        }
                    }
                }
            }
        }
        api.getMyLists()
    }

    func deleteList(_ uuid: String) {
        // This all goes very much to shit, when internet is down.
        // Really, we should put a soft delete, wait for the 200 and then do a proper delete.
        do {
            let stmt = try db.prepare("DELETE FROM alist_kv WHERE uuid=?;")
            try stmt.run(uuid)
        } catch {
            return
        }

        let api = LearnalistApi(settings: self.getSettings())
        api.deleteList(uuid)
    }
}


