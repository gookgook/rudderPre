//
//  PartyDetail.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/25.
//

import Foundation

struct PartyDetail: Codable {
    /*let alcoholCount: Int
    let alcoholCurrency, alcoholImageUrl, alcoholName: String
    let alcoholPrice: Int
    let alcoholUnit: String*/
    let applyCount, currentNumberOfMember: Int
    let partyDescription: String
    let partyId: Int
    let partyLocation, partyThumbnailUrl: String
    let partyTime: String
    let partyTitle: String
    let totalNumberOfMember: Int
    let universityName: String
    let partyStatus: String
}
