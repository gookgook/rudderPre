//
//  PartyDetailViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/25.
//

import Foundation

class PartyDetailViewModel {
    var partyDetail: PartyDetail!
    
    let getPartyDetailFlag: Observable<Int?> = Observable(nil)
}

extension PartyDetailViewModel {
    func requestPartyDetail(partyId: Int) {
        RequestPartyDetail.uploadInfo(partyId: partyId, completion: { (partyDetail: PartyDetail?) in
            guard let partyDetail = partyDetail else {
                self.getPartyDetailFlag.value = -1
                return
            }
            self.partyDetail = partyDetail
            self.getPartyDetailFlag.value = 1
        })
    }
}
