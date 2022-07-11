//
//  MyPreViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/30.
//

import Foundation

class MyPreViewModel {
    var myPartyDates: [MyPartyDate] = []
    var myPartyApplicants: [PartyApplicant] = []
    var groupChatRoom: ChatRoom!
    var otoChatRooms: [ChatRoom] = []
    
    let getPartyDatesFlag: Observable<Int?> = Observable(nil)
    let getPartyApplicantsFlag: Observable<Int?> = Observable(nil)
    let getGroupChatRoomFlag: Observable<Int?> = Observable(nil)
    let getOTOChatRoomFlag: Observable<Int?> = Observable(nil)
    //let currentPartyInfo:
    
}

extension MyPreViewModel {
    func requestPartyDates() {
        RequestMyPartyDates.uploadInfo( completion: { (myPartyDates: [MyPartyDate]?) in
            guard let myPartyDates = myPartyDates else {
                self.getPartyDatesFlag.value = -1
                return
            }
            self.myPartyDates = myPartyDates
            self.getPartyDatesFlag.value = 1
        })
    }
    
    func requestPartyApplicants(partyId: Int) {
        RequestMyPartyApplicants.uploadInfo(partyId: partyId, completion: {(myPartyApplicants: [PartyApplicant]?) in
            guard let myPartyApplicants = myPartyApplicants else {
                self.getPartyApplicantsFlag.value = -1
                return
            }
            self.myPartyApplicants = myPartyApplicants
            self.getPartyApplicantsFlag.value = 1
        })
    }
    
    func requestGroupChatroom(partyId: Int) {
        RequestMyPartyGroupChatRoom.uploadInfo(partyId: partyId, completion: {(chatRoom: ChatRoom?) in
            guard let chatRoom = chatRoom else {
                self.getGroupChatRoomFlag.value = -1
                return
            }
            self.getGroupChatRoomFlag.value = 1
            self.groupChatRoom = chatRoom
        })
    }
    
    func requestOTOChatRoom(partyId: Int) {
        RequestMyPartyOTOChatRoom.uploadInfo(partyId: partyId, completion: {(chatRooms: [ChatRoom]?)
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
