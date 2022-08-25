//
//  EditProfileViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/25.
//

import Foundation

class EditProfileViewModel {
    var profileBody: String!
    
    let editResultFlag: Observable<Int?> = Observable(nil)
}

extension EditProfileViewModel {
    func requestEditProfile(){
        
        guard profileBody.count >= ConstStrings.MINIMUM_PROFILEBODY_COUNT else {
            editResultFlag.value = 2
            return
        }
        
        RequestEditProfile.uploadInfo(profileBody: profileBody, completion: {
            status in
            self.editResultFlag.value = status
        })
    }
}
