//
//  LoginInfo.swift
//  Rudder
//
//  Created by Brian Bae on 08/09/2021.
//

import Foundation

struct LoginInfo: Codable {
    let userId: String //변수이름바꾸기!!!!!!!!!!!!!!!!!!!!!!!
    let userPassword: String
    let os: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case userId,userPassword,os
        case token = "notificationToken"
    }
    
}
