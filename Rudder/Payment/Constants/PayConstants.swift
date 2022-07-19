//
//  PayConstants.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/19.
//

import Foundation

struct Constants {
    struct ApplePay {
        static let MERCHANT_IDENTIFIER: String = "REPLACE_ME"
        static let COUNTRY_CODE: String = "US"
        static let CURRENCY_CODE: String = "USD"
    }

    struct Square {
        static let SQUARE_LOCATION_ID: String = "LZWJDZRCZZDPJ"
        static let APPLICATION_ID: String  = "sandbox-sq0idb-mYMqDFLaO2hb5hwq7NXmig"
        static let CHARGE_SERVER_HOST: String = "REPLACE_ME"
        static let CHARGE_URL: String = "\(CHARGE_SERVER_HOST)/chargeForCookie"
    }
}
