//
//  MakePreViewModel.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/12.
//

import Foundation

class MakePreViewModel {
    var partyDate: String! // timestamp로?
    var participantNumber: Int!
    var locationString: String!
    var alcoholId: Int!
    
    var pickUpPlaces: [PickUpPlace] = []
    var alcohols: [Alcohol] = []
    
    var getAlcoholInfoFlag: Observable<Int?> = Observable(nil)
    var getPickUpPlacesFlag: Observable<Int?> = Observable(nil)
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
    
    
}
