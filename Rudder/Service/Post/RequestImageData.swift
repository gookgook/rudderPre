//
//  RequestImageData.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/09.
//

import Foundation

struct RequestImageData {
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
