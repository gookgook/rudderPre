//
//  SuVIewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/28.
//

import Foundation
import UIKit

class SignUpViewModel {
    var userEmail: String!
    var userPassword: String!
    var userNickname: String!
    var userProfileBody: String = ""
    
    var promotionMailAgreement: Bool!
    
    var receivedId: Int!
    
    var profileImages: [UIImage] = []
    var imageMetaDatas: [ImageMetaData] = []
    
    var nextButtonResultFlag: Observable<String?> = Observable(nil) //School name을 보내줄 수도 있어서 기형적으로 string으로 했음. flag인데 name까지 넘겨준다는게 좀 이상함
    var signUpResultFlag: Observable<Int?> = Observable(nil)
}

extension SignUpViewModel {
    func sendValidateRequest() {
        
        guard userEmail != nil else { nextButtonResultFlag.value = "5"; return }
        guard userPassword != nil else { nextButtonResultFlag.value = "5"; return }
        
        RequestEmailVerify.uploadInfo(schoolEmail: userEmail, completion: {
            status in
            self.nextButtonResultFlag.value = status
        })
    }
    
    func requestSignUp() {
        guard (profileImages.count >= ConstStrings.MINIMUM_PHOTO_COUNT && profileImages.count <= ConstStrings.MAXIMUM_PHOTO_COUNT) else { signUpResultFlag.value = 5; return }
        guard userProfileBody.count >= ConstStrings.MINIMUM_PROFILEBODY_COUNT else { signUpResultFlag.value = 4 ; return }
        
        RequestSignUp.uploadInfo(promotionMailAgreement: promotionMailAgreement, userEmail: userEmail, userPassword: userPassword, userNickname: userNickname, userProfileBody: userProfileBody, completion: { [self]
            userInfoId in
            guard let userInfoId = userInfoId else { signUpResultFlag.value = -1; return } //문제있으니 끝냄
            receivedId = userInfoId
            
            RequestPpImageUrl.uploadInfo(userInfoId: receivedId, imageMetadatas: imageMetaDatas, completion: {
                urls in
                guard let urls = urls else { self.signUpResultFlag.value = -1; return }
                let uploadGroup = DispatchGroup()
                var everythingOkay: Bool = true //사진 하나라도 업로드 실패하면 포문 끊어주기 위함
                for i in 0..<urls.count {
                    guard everythingOkay else  {self.signUpResultFlag.value = -1; return }
                    uploadGroup.enter()
                    RequestPhotoUpload.uploadInfo(photoURL: urls[i], photoData: self.profileImages[i].jpegData(compressionQuality: 0)!, contentType: self.imageMetaDatas[i].contentType, completion: {
                        status in
                        if status != 1 {everythingOkay = false}
                        uploadGroup.leave()
                    })
                }
                uploadGroup.notify(queue: .main) {
                    self.signUpResultFlag.value = 1
                }
            })
        })
    }
}

