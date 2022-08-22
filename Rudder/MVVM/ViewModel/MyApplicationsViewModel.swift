//
//  MyApplicationsViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/18.
//

import Foundation

class MyApplicationsViewModel {
    var approvedParties: [Party] = []
    var appliedParties: [Party] = []
    
    var groupChatRooms: [ChatRoom?] = [] //parties와 맞추기 위해서
    var tmpOtoChatRooms: [ChatRoom] = [] // ''
    var otoChatRooms: [ChatRoom?] = []
    
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
            self.approvedParties = parties
            self.setGroupChatRoomsArray(count: parties.count)
            let uploadGroup = DispatchGroup()
            var everythingOkay: Bool = true //채팅방 하나라도 못받아오면 포문 끊어주기 위함
            for i in 0..<parties.count {
                guard everythingOkay else { self.getApprovedPreFlag.value = -1; return }
                guard parties[i].partyStatus == "confirmed" else { continue }
                uploadGroup.enter()
                RequestPartyGroupChatRoom.uploadInfo(partyId: parties[i].partyId, completion: {(chatRoom: ChatRoom?) in
                    if chatRoom == nil { everythingOkay = false }
                    else { self.groupChatRooms[i] = chatRoom! }
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
            self.appliedParties = parties
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
            self.tmpOtoChatRooms = chatRooms
        })
    }
}

extension MyApplicationsViewModel {
    func setGroupChatRoomsArray(count: Int){ // Parties와 맞추기 위함
        for _ in 0 ..< count {
            self.groupChatRooms.append(nil)
        }
    }
    func setOTOChatRoomsArray(){
        for _ in 0 ..< self.appliedParties.count {
            self.otoChatRooms.append(nil)
        }
        for i in 0 ..< self.tmpOtoChatRooms.count {
            self.otoChatRooms.append(tmpOtoChatRooms[i])
        }
    }
}
