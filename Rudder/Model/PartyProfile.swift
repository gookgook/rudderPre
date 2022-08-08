//
//  PartyProfile.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/08.
//

import Foundation

struct PartyProfile: Codable {
    let partyProfileBody: String
    let partyProfileId: Int
    let partyProfileImages: [String]
    let schoolImageUrl: String
    let schoolName: String
    let userNickname: String
}
