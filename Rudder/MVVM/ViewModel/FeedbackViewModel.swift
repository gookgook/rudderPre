//
//  FeedbackViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/25.
//

import Foundation

class FeedbackViewModel {
    let sendFeedbackResultFlag : Observable<Int?> = Observable(nil)
    var feedbackBody: String!
}

extension FeedbackViewModel {
    func requestFeedback() {
        guard feedbackBody.isEmpty == false else {
            sendFeedbackResultFlag.value = 2
            return
        }
        RequestFeedback.uploadInfo(feedbackBody: feedbackBody) {
            status in
            self.sendFeedbackResultFlag.value = status
        }
    }
}
