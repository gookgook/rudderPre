//
//  MyPreViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/30.
//

import Foundation

final class MyPreViewModel {
    
    init(){
        let k_moveToNotification = Notification.Name("chatReceived") //이거이름재설정 필요
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedChat(notification:)), name: k_moveToNotification, object: nil)
        
        let k_newApplication = Notification.Name("newApplication")
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNoti(notification:)), name: k_newApplication, object: nil)
    }
    
    var myPartyDates: [MyPartyDate] = []
    var myPartyApplicants: [PartyApplicant] = []
    var groupChatRoom: ChatRoom!
    var otoChatRooms: [ChatRoom] = []
    
    let getPartyDatesFlag: Observable<Int?> = Observable(nil)
    let getPartyApplicantsFlag: Observable<Int?> = Observable(nil)
    let getGroupChatRoomFlag: Observable<Int?> = Observable(nil)
    let getOTOChatRoomFlag: Observable<Int?> = Observable(nil)
    
    let receivedGroupChatFlag: Observable<Int?> = Observable(nil)
    var receivedOTOChatFlag: [Observable<Int?>] = []
    
    let refreshFlag: Observable<Bool> = Observable(false)
    let isLoadingFlag: Observable<Bool> = Observable(false)
    //let currentPartyInfo:
}

extension MyPreViewModel {
    
    func prepareForRefresh(){
        myPartyDates = []
        myPartyApplicants = []
        otoChatRooms = []
        receivedOTOChatFlag = []
    }
    
    func requestPartyDates() {
        
        self.isLoadingFlag.value = true
        RequestMyPartyDates.uploadInfo( completion: { (myPartyDates: [MyPartyDate]?) in
            guard let myPartyDates = myPartyDates else {
                self.getPartyDatesFlag.value = -1
                return
            }
            self.myPartyDates = myPartyDates
            self.isLoadingFlag.value = false
            self.getPartyDatesFlag.value = 1
        })
    }
    
    
    func requestPartyApplicants(partyId: Int) {
        print("REQUESTPartyApplicants called")
        self.isLoadingFlag.value = true
        RequestMyPartyApplicants.uploadInfo(partyId: partyId, completion: {(myPartyApplicants: [PartyApplicant]?) in
            guard let myPartyApplicants = myPartyApplicants else {
                self.getPartyApplicantsFlag.value = -1
                return
            }
            self.myPartyApplicants = myPartyApplicants
            self.isLoadingFlag.value = false
            self.getPartyApplicantsFlag.value = 1
        })
    }
    
    func requestGroupChatroom(partyId: Int) {
        self.isLoadingFlag.value = true
        RequestPartyGroupChatRoom.uploadInfo(partyId: partyId, completion: {(chatRoom: ChatRoom?) in
            guard let chatRoom = chatRoom else {
                self.getGroupChatRoomFlag.value = -1
                return
            }
            self.groupChatRoom = chatRoom
            self.isLoadingFlag.value = false
            self.getGroupChatRoomFlag.value = 1
        })
    }
    
    func requestOTOChatRoom(partyId: Int) {
        self.isLoadingFlag.value = true
        RequestMyPartyOTOChatRoom.uploadInfo(partyId: partyId, completion: {(chatRooms: [ChatRoom]?)
            in
            guard let chatRooms = chatRooms else {
                self.getOTOChatRoomFlag.value = -1
                return
            }
            self.otoChatRooms = chatRooms
            self.getOTOChatRoomFlag.value = 1
            for _ in 0..<self.otoChatRooms.count {
                self.receivedOTOChatFlag.append(Observable(nil))
            }
            
            self.isLoadingFlag.value = false
        })
    }
    
}
extension MyPreViewModel {
    
    @objc func receivedChat(notification: NSNotification){
        let currentChat = notification.userInfo!["receivedChat"] as? Chat
        
        guard groupChatRoom != nil else { return }  //지워야함
        
        if currentChat?.chatRoomId == groupChatRoom.chatRoomId {
            groupChatRoom.recentMessage = currentChat?.chatMessageBody
            receivedGroupChatFlag.value = 1
        } else {
            for i in 0..<otoChatRooms.count {
                if otoChatRooms[i].chatRoomId == currentChat?.chatRoomId {
                    otoChatRooms[i].recentMessage = currentChat?.chatMessageBody
                    receivedOTOChatFlag[i].value = 1
                    break
                }
            }
        }
    }
    
    @objc func receivedNoti(notification: NSNotification) {
        refreshFlag.value = true
    }
}


