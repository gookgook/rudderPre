//
//  ProfileViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/08.
//

import Foundation

class ProfileViewModel {
    var profile: PartyProfile!
    
    let getProfileFlag: Observable<Int?>  = Observable(nil)
    let acceptResultFlag: Observable<Int?> = Observable(nil)
    let sendMessageFlag: Observable<Int?> = Observable(nil)
}

extension ProfileViewModel {
    func requestProfile(userInfoId: Int){
        RequestProfile.uploadInfo(userInfoId: userInfoId, completion: {(partyProfile: PartyProfile?) in
            guard let partyProfile = partyProfile else {
                self.getProfileFlag.value = -1
                return
            }
            self.profile = partyProfile
            self.getProfileFlag.value = 1
        })
    }
    
    func requestAcceptApplicant(partyId: Int, partyMemberId: Int){
        RequestAcceptApplicant.uploadInfo(partyId: partyId, partyMemberId: partyMemberId, completion: {
            status in
            self.acceptResultFlag.value = status
        })
    }
    
    func requestSendMessage(partyId: Int, applicantUserInfoId: Int) {
        let myUserInfoId = UserDefaults.standard.integer(forKey: "userInfoId")
        RequestCreateChatRoom.uploadInfo(partyId: partyId, userInfoIdList: [myUserInfoId,applicantUserInfoId], completion: {(chatRoomId: Int?) in
            self.sendMessageFlag.value = chatRoomId
        })
    }
}
