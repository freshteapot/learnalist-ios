import SwiftyJSON

struct SettingsInfo {
    var username: String
    var password: String
    func toString() -> String {
        let json = JSON([
            "username": username,
            "password": password
            ])
        return json.rawString()!
    }
}
