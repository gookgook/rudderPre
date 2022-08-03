//
//  Party.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/07.
//

import Foundation

struct Party: Codable {
    let applyCount: Int
    let currentNumberOfMember: Int
    let partyId: Int
    let partyStatus: String
    let partyThumbnailUrl: String
    let partyTime: String
    let partyTitle: String
    let totalNumberOfMember: Int
    let universityName: String
    let universityLogoUrl: String
}
