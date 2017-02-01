import SwiftyJSON

struct SettingsInfo {
    var username: String
    var password: String
    var server: String

    func toString() -> String {
        let json = JSON([
            "username": username,
            "password": password,
            "server": server,
            ])
        return json.rawString()!
    }
}
