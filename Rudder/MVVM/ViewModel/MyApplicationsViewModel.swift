//
//  MyApplicationsViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/18.
//

import Foundation

class MyApplicationsViewModel {
    var approvedParty: [Party] = []
    
    var appliedParty: [Party] = []
    var groupChatRoom: [ChatRoom] = []
    var otoChatRooms: [ChatRoom] = []
    
    let getApprovedPreFlag: Observable<Int?> = Observable(nil)
    let getAppliedPreFlag: Observable<Int?> = Observable(nil)
    let getOTOChatRoomFlag: Observable<Int?> = Observable(nil)

}

extension MyApplicationsViewModel {
    func requestApprovedParties() {
        RequestApprovedPre.uploadInfo(completion: {(parties: [Party]?) in
            guard let parties = parties else {
                self.getApprovedPreFlag.value = -1
                return
            }
            self.approvedParty = parties
            let uploadGroup = DispatchGroup()
            var everythingOkay: Bool = true //채팅방 하나라도 못받아오면 포문 끊어주기 위함
            for i in 0..<parties.count {
                guard everythingOkay else { self.getApprovedPreFlag.value = -1; return }
                guard parties[i].partyStatus == "confirmed" else { continue }
                uploadGroup.enter()
                RequestPartyGroupChatRoom.uploadInfo(partyId: parties[i].partyId, completion: {(chatRoom: ChatRoom?) in
                    if chatRoom == nil { everythingOkay = false }
                    else { self.groupChatRoom.append(chatRoom!) }
                    uploadGroup.leave()
                })
            }
            uploadGroup.notify(queue: .main) {
                self.getApprovedPreFlag.value = 1
            }
        })
    }
    
    func requestAppliedPre() {
        RequestAppliedPre.uploadInfo( completion: { (parties: [Party]?) in
            guard let parties = parties else {
                self.getAppliedPreFlag.value = -1
                return
            }
            self.appliedParty = parties
            self.getAppliedPreFlag.value = 1
        })
    }
    
    func requestOTOChatRoom() {
        RequestPartyOTOChatRoom.uploadInfo(completion: {(chatRooms: [ChatRoom]?)
            in
            guard let chatRooms = chatRooms else {
                self.getOTOChatRoomFlag.value = -1
                return
            }
            self.getOTOChatRoomFlag.value = 1
            self.otoChatRooms = chatRooms
        })
    }
}
