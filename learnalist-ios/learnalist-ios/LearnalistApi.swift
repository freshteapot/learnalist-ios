//
//  LearnalistApi.swift
//  learnalist-ios
//
//  Created by Chris Williams on 01/02/2017.
//  Copyright © 2017 freshteapot. All rights reserved.
//

import Foundation
import Alamofire
import Signals


class LearnalistApi {
    var settings:SettingsInfo!
    var baseUrl:String!
    let onResponse = Signal<Alamofire.DataResponse<Any>>()

    init(settings:SettingsInfo) {
        self.setSettings(settings: settings)
    }

    func setSettings(settings:SettingsInfo) {
        self.baseUrl = settings.server
        self.settings = settings
    }

    func getMyLists() {
        let url = self.baseUrl + "/alist/by/me"

        let user = self.settings.username
        let password = self.settings.password

        Alamofire.request(url, method: .get)
            .authenticate(user: user, password: password)
            .responseJSON { response in
                self.onResponse.fire(response)
        }
    }

    func deleteList(_ uuid: String) {

        let url = self.baseUrl + "/alist/\(uuid)"

        let user = self.settings.username
        let password = self.settings.password

        Alamofire.request(url, method: .delete)
            .authenticate(user: user, password: password)
            .responseJSON { response in
                self.onResponse.fire(response)
        }
    }


    func postList(listType: String, body: String) {

        let url = self.baseUrl + "/alist"

        let user = self.settings.username
        let password = self.settings.password
        let parameters = JSONParseToDictionary(text: body)

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .authenticate(user: user, password: password)
            .responseJSON { response in
                self.onResponse.fire(response)
        }
    }

    func putList(uuid: String, listType: String, body: String) {
        if uuid.isEmpty {
            print ("This is not allowed")
            return
        }

        let url = self.baseUrl + "/alist/\(uuid)"

        let user = self.settings.username
        let password = self.settings.password
        let parameters = JSONParseToDictionary(text: body)

        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .authenticate(user: user, password: password)
            .responseJSON { response in
                self.onResponse.fire(response)
        }
    }
}
