//
//  Protocols.swift
//  Rudder
//
//  Created by 박민호 on 2022/01/19.
//

import Foundation

protocol DoRefreshDelegate {
    func doRefreshChange()
}

protocol DoUpdateCharacterDelegate {
    func doUpdateCharacter()
}

protocol DoUpdatePostBodyDelegate {
    func doUpdatePostBody(postBody: String)
}

protocol DoUpdateLikeButtonDelegate {
    func doUpdateLikeButton(likeCount: Int) // +1 or -1
}

protocol DoUpdateCommentCountDelegate {
    func doUpdateCommentCount(commentCount: Int) // +1 or -1
}

protocol GoSomePageDelegate: AnyObject {
    func goSomePage()
}

protocol DoApplyDelegate: AnyObject {
    func doApply(numberOfApplicants: Int)
}

protocol DoRefreshPartyDelegate: AnyObject {
    func doRefreshParty()
}

protocol DoGoChatRoomDelegate: AnyObject {
    func doGoChatRoomDelegate(chatRoomId: Int)
}

protocol DoUpdateProfileDelegate: AnyObject {
    func doUpdateProfile()
}
