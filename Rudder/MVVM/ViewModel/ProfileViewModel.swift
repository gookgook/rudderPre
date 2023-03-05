//
//  ProfileViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/08.
//

import Foundation

final class ProfileViewModel {
    var profile: PartyProfile!
    
    let getProfileFlag: Observable<Int?>  = Observable(nil)
    let acceptResultFlag: Observable<Int?> = Observable(nil)
    let sendMessageFlag: Observable<Int?> = Observable(nil)
    let currentImageNo: Observable<Int> = Observable(0)
    
    let isLoadingFlag: Observable<Bool> = Observable(false)
}

extension ProfileViewModel {
    func requestProfile(userInfoId: Int){
        isLoadingFlag.value = true
        RequestProfile.uploadInfo(userInfoId: userInfoId, completion: {(partyProfile: PartyProfile?) in
            self.isLoadingFlag.value = false
            guard let partyProfile = partyProfile else {
                self.getProfileFlag.value = -1
                return
            }
            self.profile = partyProfile
            self.getProfileFlag.value = 1
        })
    }
    
    func requestAcceptApplicant(partyId: Int, partyMemberId: Int){
        isLoadingFlag.value = true
        RequestAcceptApplicant.uploadInfo(partyId: partyId, partyMemberId: partyMemberId, completion: {
           
            status in
            self.isLoadingFlag.value = false
            self.acceptResultFlag.value = status
        })
    }
    
    func requestSendMessage(partyId: Int, applicantUserInfoId: Int) {
        isLoadingFlag.value = true
        let myUserInfoId = UserDefaults.standard.integer(forKey: "userInfoId")
        RequestCreateChatRoom.uploadInfo(partyId: partyId, userInfoIdList: [myUserInfoId,applicantUserInfoId], completion: {(chatRoomId: Int?) in
            self.isLoadingFlag.value = false
            print("chatRoomId ", String(chatRoomId!))
            self.sendMessageFlag.value = chatRoomId
        })
    }
    
    func handleImageSwipe(direction: Int) {//1: left, 2:right
        if direction == 1 && currentImageNo.value < profile.partyProfileImages.count - 1  {
            currentImageNo.value += 1
        } else if direction == 2 && currentImageNo.value > 0 {
            currentImageNo.value -= 1
        }
    }
}
