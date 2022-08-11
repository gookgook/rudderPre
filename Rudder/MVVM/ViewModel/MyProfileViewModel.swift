//
//  MyProfileViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/11.
//

import Foundation

class MyProfileViewModel {
    var profile: PartyProfile!
    var profileBody: String!
    
    let getProfileFlag: Observable<Int?> = Observable(nil)
    let editResultFlag: Observable<Int?> = Observable(nil)
}

extension MyProfileViewModel {
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
    
    func requestEditProfile(){
        guard profileBody.count >= ConstStrings.MINIMUM_PROFILEBODY_COUNT else { editResultFlag.value = 4 ; return }
        RequestEditProfile.uploadInfo(profileBody: profileBody, completion: {
            status in
            self.editResultFlag.value = status
        })
    }
}
