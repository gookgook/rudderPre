//
//  PartyMainViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/07.
//

import Foundation

class PartyMainViewModel {
    var parties: [Party] = []
    
    let getPartiesFlag: Observable<Int?> = Observable(nil)
}

extension PartyMainViewModel {
    func requestPartyDates(endPartyId: Int) {
        RequestParties.uploadInfo(endPartyId: endPartyId, completion: { (parties: [Party]?) in
            guard let parties = parties else {
                self.getPartiesFlag.value = -1
                return
            }
            self.parties = parties
            self.getPartiesFlag.value = 1
        })
    }
    
    @objc func reloadPosts() {
        requestPartyDates(endPartyId: -1)// 이부분 해결해야함
    }
}
