//
//  PartyFeedbackViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/25.
//

import Foundation

class PartyFeedbackViewModel {
    let sendFeedbackResultFlag : Observable<Int?> = Observable(nil)
    var feedbackBody: String!
    var feedbackType: String!
}

extension PartyFeedbackViewModel {
    func requestFeedback( partyId: Int){
        guard feedbackBody.isEmpty == false else {
            sendFeedbackResultFlag.value = 2
            return
        }
        RequestPartyFeedback.uploadInfo(customerSoundBody: feedbackBody, customerSoundType: feedbackType, partyId: partyId) {
            status in
            self.sendFeedbackResultFlag.value = status
        }
    }
}
