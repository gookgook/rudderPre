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

    let isLoadingFlag: Observable<Bool> = Observable(false)
}

extension FeedbackViewModel {
    func requestFeedback() {
        guard feedbackBody.isEmpty == false else {
            sendFeedbackResultFlag.value = 2
            return
        }
        isLoadingFlag.value = true
        RequestFeedback.uploadInfo(feedbackBody: feedbackBody) {
            status in
            self.isLoadingFlag.value = false
            self.sendFeedbackResultFlag.value = status
        }
    }
}
