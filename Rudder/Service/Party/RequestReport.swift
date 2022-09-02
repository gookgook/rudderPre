//
//  RequestReport.swift
//  Rudder
//
//  Created by 박민호 on 2022/09/01.
//

import Foundation

struct RequestReport {
    static func uploadInfo(itemId: Int , reportBody: String, reportType: String, completion: @escaping (Int) -> Void) -> Void{
        let url = URL(string: Utils.springUrlKey+"/reports")!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
      
        let feedback = Report(itemId: itemId, reportBody: reportBody, reportType: reportType)
        guard let EncodedUploadData = try? JSONEncoder().encode(feedback) else {
            return
        }
        
        let task = URLSession.shared.uploadTask(with: request, from: EncodedUploadData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                completion(-1)
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                completion(-1)
                return
            }
            completion(1)
        })
        task.resume()
    }
}

extension RequestReport {
    struct Report: Codable {
        let itemId: Int
        let reportBody: String
        let reportType: String
    }
}
