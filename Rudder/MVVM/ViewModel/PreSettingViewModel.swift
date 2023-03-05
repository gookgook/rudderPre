//
//  PreSettingViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/13.
//

import Foundation

final class PreSettingViewModel {
    let cancellationFlag: Observable<Int?> = Observable(nil)
    let stopRecruiFlag: Observable<Int?> = Observable(nil)
    let fixTheMembersFlag: Observable<Int?> = Observable(nil)
}

extension PreSettingViewModel {
    func requestCancellation(partyId: Int){
        RequestCancelParty.uploadInfo(partyId: partyId, completion: {
            status in
            self.cancellationFlag.value = status
        })
    }
    
   func requestStopRecruit(partyId: Int){
        RequestStopRecruit.uploadInfo(partyId: partyId, completion: {
            status in
            self.stopRecruiFlag.value = status
        })
    }
    
    func requestFixMembers(partyId: Int){
        RequestFixMembers.uploadInfo(partyId: partyId, completion: {
            status in
            self.fixTheMembersFlag.value = status
        })
    }
}

