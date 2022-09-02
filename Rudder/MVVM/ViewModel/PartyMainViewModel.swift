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
    
    let notiInitFlag: Observable<Bool> = Observable(false) // 1 if no noti, 2 if noti exists
    
    let newNotiFlag: Observable<Bool> = Observable(false)
    let isLoadingFlag: Observable<Bool> = Observable(false)
    
    var nowPaging = false
    
    init() {
        handleNotis()
    }
}

extension PartyMainViewModel {
    func handleNotis(){
        let k_accepted = Notification.Name("accepted") //이거이름재설정 필요
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNoti(notification:)), name: k_accepted, object: nil)
        let k_newApplication = Notification.Name("newApplication")
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNoti(notification:)), name: k_newApplication, object: nil)
    }
    
    @objc func receivedNoti(notification: NSNotification){
        newNotiFlag.value = true
    }
    
}

extension PartyMainViewModel {
    
    func requestInitialData(){
        RequestInitialData.uploadInfo() {
            status in
            if status == 1 {self.notiInitFlag.value = false}
            else {self.notiInitFlag.value = true}
        }
    }
    
    func requestPartyDates(endPartyId: Int, isInfiniteScroll: Bool) {
        isLoadingFlag.value = true
        
        RequestParties.uploadInfo(endPartyId: endPartyId, completion: { (parties: [Party]?) in
            guard let parties = parties else {
                self.getPartiesFlag.value = -1
                return
            }
            if parties.count == 0 {self.getPartiesFlag.value = 2 }
            
            if isInfiniteScroll {self.parties += parties}
            else {self.parties = parties }
            self.getPartiesFlag.value = 1
            self.isLoadingFlag.value = false
        })
    }
    
    @objc func reloadPosts() {
        requestPartyDates(endPartyId: -1, isInfiniteScroll: false)// 이부분 해결해야함
    }
}
