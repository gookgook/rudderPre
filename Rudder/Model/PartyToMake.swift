//
//  PartyToMake.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/12.
//

import Foundation

struct PartyToMake :Codable {
    let alcoholId: Int
    let location: String
    let partyDescription: String
    let partyTime: String
    let partyTitle: String
    let totalNumberOfMember: Int
}
