import Foundation
import Gloss

func JSONParseToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

func JSONStringify(_ json: JSON, pretty:Bool) -> String {
    var jsonString = ""
    do {
        var options = JSONSerialization.WritingOptions()
        if pretty {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }

        let jsonData = try JSONSerialization.data(withJSONObject: json, options: options) as NSData
        jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
    } catch {
        // @todo probably do something more interesting here
        print ("JSON Failure")
    }
    return jsonString
}

struct AlistSummary: Decodable {
    var title: String
    var listType: String
    var uuid: String

    init(uuid: String, listType: String, title: String) {
        self.title = title
        self.listType = listType
        self.uuid = uuid
    }

    init?(json: JSON) {
        self.uuid = ("uuid" <~~ json)!
        self.listType = ("type" <~~ json)!
        self.title = ("title" <~~ json)!
    }

    func toJSON() -> JSON? {
        return jsonify([
            "uuid" ~~> self.uuid,
            "type" ~~> self.listType,
            "title" ~~> self.title,
            ])
    }

}

struct AlistInfo: Decodable {
    var title: String
    var listType: String
    var from: String?

    init(title: String, listType: String, from: String?) {
        self.title = title
        self.listType = listType
        self.from = from
    }

    init?(json: JSON) {
        self.title = ("title" <~~ json)!
        self.listType = ("type" <~~ json)!
        self.from = "from" <~~ json
    }

    func toJSON() -> JSON? {
        return jsonify([
            "title" ~~> self.title,
            "type" ~~> self.listType,
            "from" ~~> self.from
            ])
    }
}

struct AlistV1: Decodable {
    var uuid: String
    var info: AlistInfo
    var data: [String]

    static func NewList(_ uuid: String) -> AlistV1 {
        // By default, we set both uuid and info.from to be the same uuid.
        return AlistV1(
            uuid: uuid,
            info: AlistInfo(
                title:"I am a title",
                listType:"v1",
                from: uuid
            ),
            data: [String]()
        )
    }

    init(uuid: String, info: AlistInfo, data: [String]) {
        self.uuid = uuid
        self.info = info
        self.data = data
    }

    // MARK: - Deserialization

    init?(json: JSON) {
        self.uuid = ("uuid" <~~ json)!
        self.info = ("info" <~~ json)!
        self.data = ("data" <~~ json)!
    }

    func toJSON() -> JSON? {
        return jsonify([
            "uuid" ~~> self.uuid,
            "info" ~~> self.info.toJSON(),
            "data" ~~> self.data
            ])
    }
}


struct AlistV2: Decodable {
    var uuid: String
    var info: AlistInfo
    var data: [String: String]
    init(uuid: String, info: AlistInfo, data: [String: String]) {
        self.uuid = uuid
        self.info = info
        self.data = data
    }

    // MARK: - Deserialization

    init?(json: JSON) {
        self.uuid = ("uuid" <~~ json)!
        self.info = ("info" <~~ json)!
        self.data = ("data" <~~ json)!
    }

    func toJSON() -> JSON? {
        return jsonify([
            "uuid" ~~> self.uuid,
            "info" ~~> self.info.toJSON(),
            "data" ~~> self.data
            ])
    }
}


func testing() {

    let testV1 = "{\"data\":[\"monday\",\"tuesday\",\"wednesday\",\"thursday\",\"friday\",\"saturday\",\"sunday\"],\"info\":{\"title\":\"Days of the Week\",\"type\":\"v1\"},\"uuid\":\"392d03ca-bb60-53a6-adb8-7565fad37da5\"}"

    let testV2 = "{\"data\":{\"car\":\"bil\",\"water\":\"vann\"},\"info\":{\"title\":\"The UI is alive, but not editable.\",\"type\":\"v2\"},\"uuid\":\"8f426d3b-7060-5c7f-aa9d-5976a4e2ce59\"}"

    if var test = AlistV1(json: JSONParseToDictionary(text: testV1)!) {
        print(test)
        test.data.append("Chris")
        print(JSONStringify(test.toJSON()!, pretty:true))
    }

    if var test = AlistV2(json: JSONParseToDictionary(text: testV2)!) {
        print(test)
        test.data["chris"] = "tired"
        print(JSONStringify(test.toJSON()!, pretty:true))
    }
}
