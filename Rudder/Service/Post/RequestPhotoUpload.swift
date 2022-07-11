//
//  RequestPhotoUpload.swift
//  Rudder
//
//  Created by Brian Bae on 08/09/2021.
//

import Foundation

struct RequestPhotoUpload {
    //login
    static func uploadInfo(photoURL: String, photoData: Data, contentType: String ,completion: @escaping (Int) -> Void) -> Void{
        
        print("photoURL " + photoURL)
        
        let url = URL(string: photoURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
      
        let task = URLSession.shared.uploadTask(with: request, from: photoData, completionHandler: { (data, response, error) in
            if let error = error {
                print ("error: \(error)")
                completion(-1)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                
                print ("server error when upload photo")
                completion(-1)
                return
            }
            
            completion(1)
        })
        task.resume()
    }
}
