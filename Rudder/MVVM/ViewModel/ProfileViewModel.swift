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
}
