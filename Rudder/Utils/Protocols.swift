//
//  Protocols.swift
//  Rudder
//
//  Created by 박민호 on 2022/01/19.
//

import Foundation

protocol DoRefreshDelegate: AnyObject {
    func doRefreshChange()
}

protocol DoUpdateCharacterDelegate: AnyObject {
    func doUpdateCharacter()
}

protocol DoUpdatePostBodyDelegate: AnyObject {
    func doUpdatePostBody(postBody: String)
}

protocol DoUpdateLikeButtonDelegate: AnyObject {
    func doUpdateLikeButton(likeCount: Int) // +1 or -1
}

protocol DoUpdateCommentCountDelegate: AnyObject {
    func doUpdateCommentCount(commentCount: Int) // +1 or -1
}

protocol GoSomePageDelegate: AnyObject {
    func goSomePage()
}

protocol DoApplyDelegate: AnyObject {
    func doApply(numberOfApplicants: Int, recommendationCode: String)
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

protocol DoUpdateAcceptButtonDelegate: AnyObject {
    func doUpdateAcceptButton()
}

protocol DoRefreshMyPreDelegate: AnyObject {
    func doRefreshMyPre()
}
