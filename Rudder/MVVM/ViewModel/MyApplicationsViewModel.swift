//
//  MyApplicationsViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/18.
//

import Foundation

final class MyApplicationsViewModel {
    
    init(){
        let k_moveToNotification = Notification.Name("chatReceived") //이거이름재설정 필요
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedChat(notification:)), name: k_moveToNotification, object: nil)
        
        let k_accepted = Notification.Name("accepted") //이거이름재설정 필요
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNoti(notification:)), name: k_accepted, object: nil)
        
        
        let k_newChatRoom = Notification.Name("newChatRoom")
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNoti(notification:)), name: k_newChatRoom, object: nil)
    }
    
    var approvedParties: [Party] = []
    var appliedParties: [Party?] = []
    var tmpAppliedParties: [Party] = []
    
    var groupChatRooms: [ChatRoom?] = [] //parties와 맞추기 위해서
    var otoChatRooms: [ChatRoom?] = []
    
    let getApprovedPreFlag: Observable<Int?> = Observable(nil)
    let getAppliedPreFlag: Observable<Int?> = Observable(nil)
    let getOTOChatRoomFlag: Observable<Int?> = Observable(nil)
    
    var receivedGroupChatFlag: [Observable<Int?>] = []
    var receivedOTOChatFlag: [Observable<Int?>] = []
    
    var refreshFlag: Observable<Bool> = Observable(false)

    var isLoadingFlag: Observable<Bool> = Observable(false)
}

extension MyApplicationsViewModel {
    func prepareForRefresh(){
        
        approvedParties = []
        appliedParties = []
        tmpAppliedParties = []
        groupChatRooms = []
        otoChatRooms = []
        receivedOTOChatFlag = []
        receivedOTOChatFlag = []
    }
    
    
    func requestApprovedParties() {
        
        isLoadingFlag.value = true
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
                guard parties[i].partyStatus == "FINAL_APPROVE" else { continue }
                print("chel")
                uploadGroup.enter()
                RequestPartyGroupChatRoom.uploadInfo(partyId: parties[i].partyId, completion: {(chatRoom: ChatRoom?) in
                    if chatRoom == nil { everythingOkay = false }
                    else {
                        self.groupChatRooms[i] = chatRoom!
                        
                    }
                    uploadGroup.leave()
                })
            }
            uploadGroup.notify(queue: .main) {
                print("group chat room count " + String(self.groupChatRooms.count))
                self.getApprovedPreFlag.value = 1
                self.isLoadingFlag.value = false
            }
        })
    }
    
    func requestAppliedPre() {
        isLoadingFlag.value = true
        RequestAppliedPre.uploadInfo( completion: { (parties: [Party]?) in
            guard let parties = parties else {
                self.getAppliedPreFlag.value = -1
                return
            }
            
            
            self.tmpAppliedParties = parties
            print("tmpAppliedPartiesCount " + String(self.tmpAppliedParties.count))
            self.getAppliedPreFlag.value = 1
            self.isLoadingFlag.value = false
            
        })
    }
    func requestOTOChatRoom() {
        isLoadingFlag.value = true
        RequestPartyOTOChatRoom.uploadInfo(completion: {(chatRooms: [ChatRoom]?)
            in
            guard let chatRooms = chatRooms else {
                self.getOTOChatRoomFlag.value = -1
                return
            }
            self.otoChatRooms = chatRooms
            self.setOTOChatRoomsArray()
            
            self.getOTOChatRoomFlag.value = 1
            self.isLoadingFlag.value = false
        })
    }
}

extension MyApplicationsViewModel {
    func setGroupChatRoomsArray(count: Int){ // Parties와 맞추기 위함
        for _ in 0 ..< count {
            self.groupChatRooms.append(nil)
            self.receivedGroupChatFlag.append(Observable(nil))
        }
    }
    func setOTOChatRoomsArray(){
        for _ in 0 ..< self.otoChatRooms.count {
            self.appliedParties.append(nil)
        }
        for i in 0 ..< self.tmpAppliedParties.count {
            receivedOTOChatFlag.append(Observable(nil))
            if tmpAppliedParties[i].isChatExist == false {
                self.appliedParties.append(tmpAppliedParties[i])
            }
        }
    }
}

extension MyApplicationsViewModel {
    @objc func receivedChat(notification: NSNotification){
        let currentChat = notification.userInfo!["receivedChat"] as? Chat
        
        for i in 0..<groupChatRooms.count {
            if groupChatRooms[i]!.chatRoomId == currentChat?.chatRoomId {
                groupChatRooms[i]!.recentMessage = currentChat?.chatMessageBody
                receivedGroupChatFlag[i].value = 1
                break
            }
        }
        
        for i in 0..<otoChatRooms.count {
            guard otoChatRooms[i] != nil else {continue}
            if otoChatRooms[i]!.chatRoomId == currentChat?.chatRoomId {
                otoChatRooms[i]!.recentMessage = currentChat?.chatMessageBody
                receivedOTOChatFlag[i].value = 1
                break
            }
        }
    }
    
    @objc func receivedNoti(notification: NSNotification) {
        refreshFlag.value = true
    }
}
