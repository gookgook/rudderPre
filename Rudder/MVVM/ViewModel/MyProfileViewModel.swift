//
//  MyProfileViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/11.
//

import Foundation

class MyProfileViewModel {
    var profile: PartyProfile!
    
    let getProfileFlag: Observable<Int?> = Observable(nil)
    
    let isLoadingFlag: Observable<Bool> = Observable(false)
}

extension MyProfileViewModel {
    func requestProfile(userInfoId: Int){
        isLoadingFlag.value = true
        RequestProfile.uploadInfo(userInfoId: userInfoId, completion: {(partyProfile: PartyProfile?) in
            guard let partyProfile = partyProfile else {
                self.getProfileFlag.value = -1
                return
            }
            self.profile = partyProfile
            self.getProfileFlag.value = 1
            self.isLoadingFlag.value = false
        })
    }
}
