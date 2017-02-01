
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

        if !dbExists {
            setup()
        }

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

        let query = "create table settings (username CHARACTER(36) not null primary key, data text);"
        do {
            try db.execute(query)

            var stmt = try db.prepare("SELECT name FROM sqlite_master WHERE type = 'table'")
            var schema = try stmt.scalar() as! String
            print(schema)

            stmt = try db.prepare("SELECT sql FROM sqlite_master WHERE name='settings';")
            schema = try stmt.scalar() as! String
            print(schema)

        } catch{
            print("error: \(error).")
        }
    }


    func saveSettings(settings: SettingsInfo) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(settings.username, forKey: "lal.username")
        userDefaults.set(settings.password, forKey: "lal.password")

        print("Saving settings to the db.")
        print(settings.toString())
        /*

         do {
         let stmt = try db.prepare("INSERT OR REPLACE INTO settings (username, data) VALUES ((SELECT username FROM settings WHERE username = ?), ?)")
         let username = settings.username
         let data = settings.toString()
         try stmt.run(username, data)
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
         */
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
}


