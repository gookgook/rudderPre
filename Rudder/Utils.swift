//
//  Utils.swift
//  Rudder
//
//  Created by Brian Bae on 19/08/2021.
//

import Foundation

class Utils {
    static let urlKey = Bundle.main.infoDictionary!["TestURL"] as! String
    static let springUrlKey = Bundle.main.infoDictionary!["SpringURL"] as! String
    
    static func timeAgo(postDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.isLenient = true
        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en")
        let date = dateFormatter.date(from: postDate)
        let rFormatter = RelativeDateTimeFormatter()
        rFormatter.locale = Locale(identifier: "en")
        guard date != nil else {
            return "Unknown"
        }
        let datestring = rFormatter.localizedString(for: date!, relativeTo: Date())
        return datestring
       
    }
    
    static func stringDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.isLenient = true
        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let sDateFormatter = DateFormatter()
        sDateFormatter.dateFormat="MMM d"
        sDateFormatter.locale = Locale(identifier: "en")
        let tdate = dateFormatter.date(from: date)
        
        guard tdate != nil else {
            return "Unknown"
        }
        
        let datestring = sDateFormatter.string(from: tdate!)
        return datestring
        
        
    }
    
    static func chatDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.isLenient = true
        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let sDateFormatter = DateFormatter()
        sDateFormatter.dateFormat="HH:mm"
        sDateFormatter.locale = Locale(identifier: "en")
        let tdate = dateFormatter.date(from: date)
        
        guard tdate != nil else {
            return "Unknown"
        }
        
        let datestring = sDateFormatter.string(from: tdate!)
        return datestring
    
    }
    
    static var noticeShowed:Bool = false
    static var firstScreen:Int = 0 //0 is loginVC, 1 is tmpVC
    
    static func arrayToString(data:[String]) -> String {
        var finalString : String = ""
        finalString +=  "["
        for i in 0...data.count-1 {
            finalString += "\"" + data[i] + "\""
            if i != data.count-1 { finalString += "," }
        }
        finalString += "]"
        return finalString
    }
}
