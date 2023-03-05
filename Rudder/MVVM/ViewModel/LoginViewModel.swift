//
//  LoViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/02.
//

import Foundation

final class LoginViewModel {
    var userEmail: String!
    var userPassword: String!
    
    var loginResultFlag: Observable<Int?> = Observable(nil)
    
    let isLoadingFlag: Observable<Bool> = Observable(false)
}

extension LoginViewModel{
    
    func sendLoginRequest(){
        
        guard userEmail != nil else { loginResultFlag.value = 5; return }
        guard userPassword != nil else { loginResultFlag.value = 5; return }
        
        isLoadingFlag.value = true
        
        
        let ApnToken: String = UserDefaults.standard.string(forKey: "ApnToken") ?? "ApnTokenFail"
        let loginInfo = LoginInfo(userId: userEmail, userPassword: userPassword, os: "ios", token: ApnToken)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(loginInfo) else { return }
        
        RequestBasic.uploadInfo(EncodedUploadData: EncodedUploadData, completion: {
            status in
            self.loginResultFlag.value = status
            self.isLoadingFlag.value = false
        })
    }
}


