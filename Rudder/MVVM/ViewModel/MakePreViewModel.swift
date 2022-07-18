//
//  MakePreViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/12.
//

import Foundation
import UIKit

class MakePreViewModel {
    var partyTitle: String!
    var partyDate: String! // timestamp로?
    var participantNumber: Int!
    var locationString: String!
    var alcoholId: Int!
    var partyDescription: String!
    
    var pickUpPlaces: [PickUpPlace] = []
    var alcohols: [Alcohol] = []
    
    var thumbnailImage: UIImage!
    var imageMetaData: ImageMetaData!
    
    var getAlcoholInfoFlag: Observable<Int?> = Observable(nil)
    var getPickUpPlacesFlag: Observable<Int?> = Observable(nil)
    var makePartyResultFlag: Observable<Int?> = Observable(nil)
}

extension MakePreViewModel {
    func requestPickUpPlaces() {
        RequestPickUpPlaces.uploadInfo( completion: { (pickUpPlaces: [PickUpPlace]?) in
            guard let pickUpPlaces = pickUpPlaces else {
                self.getPickUpPlacesFlag.value = -1
                return
            }
            self.pickUpPlaces = pickUpPlaces
            self.getPickUpPlacesFlag.value = 1
        })
    }
    
    func requestAlcohols() {
        RequestAlcohols.uploadInfo( completion: { (alcohols: [Alcohol]?) in
            guard let alcohols = alcohols else {
                self.getAlcoholInfoFlag.value = -1
                return
            }
            self.alcohols = alcohols
            self.getAlcoholInfoFlag.value = 1
        })
    }
    
    func requestMakeParty() {
        RequestMakePre.uploadInfo(alcoholId: alcoholId, location: locationString, partyDescription: partyDescription, partyTime: partyDate, partyTitle: partyTitle, totalNumberOfMember: participantNumber, completion: { [self]
            partyId in
            guard let partyId = partyId else { makePartyResultFlag.value = -1; return }
            RequestPtImageUrl.uploadInfo(partyId: partyId, imageMetadata: imageMetaData, completion: {
                urls in
                guard let urls = urls else { self.makePartyResultFlag.value = -1; return }
                RequestPhotoUpload.uploadInfo(photoURL: urls[0], photoData: self.thumbnailImage.jpegData(compressionQuality: 0)!, contentType: self.imageMetaData.contentType, completion: {
                    status in
                    if status != 1 {self.makePartyResultFlag.value = -1}
                    else { self.makePartyResultFlag.value = 1 }
                })
            })
        })
    }
}
