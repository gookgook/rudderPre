//
//  PartyApplicant.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/01.
//

import Foundation

struct PartyApplicant: Codable {
    let partyProfileImageUrl: String
    let userInfoId: Int
    let partyMemberId: Int
    let numberApplicants: Int
    let userNickname: String
    let isChatExist: Bool
    let partyStatus: String
}
