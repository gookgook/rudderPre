//
//  PartyDetailViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/25.
//

import Foundation

final class PartyDetailViewModel {
    var partyDetail: PartyDetail!
    
    let getPartyDetailFlag: Observable<Int?> = Observable(nil)
    let applyResultFlag: Observable<Int?> = Observable(nil)
    
    let isLoadingFlag: Observable<Bool> = Observable(false)
}

extension PartyDetailViewModel {
    func requestPartyDetail(partyId: Int) {
        isLoadingFlag.value = true
        RequestPartyDetail.uploadInfo(partyId: partyId, completion: { (partyDetail: PartyDetail?) in
            guard let partyDetail = partyDetail else {
                self.getPartyDetailFlag.value = -1
                return
            }
            self.partyDetail = partyDetail
            self.getPartyDetailFlag.value = 1
            self.isLoadingFlag.value = false
        })
    }
    func requestApplyParty(numberApplicants: Int, recommendationCode: String) {
        isLoadingFlag.value = true
        RequestApplyParty.uploadInfo(partyId: partyDetail.partyId, numberApplicants: numberApplicants, recommendationCode: recommendationCode, completion: {
            status in
            
            let k_newCHatRoom = Notification.Name("newChatRoom")
            NotificationCenter.default.post(name: k_newCHatRoom, object: nil, userInfo: nil)//MyPreViewModel 새로고침하기위해서 임시로
            self.applyResultFlag.value = status
            self.isLoadingFlag.value = false
        })
    }
}
