//
//  RequestMakePre.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/12.
//

import Foundation

struct RequestMakePre {
    //login
    static func uploadInfo(alcoholId: Int, location: String, partyDescription: String, partyTime: String, partyTitle: String, totalNumberOfMember: Int, completion: @escaping (Int?) -> Void) -> Void{
        let url = URL(string: Utils.springUrlKey+"/parties")!
        
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = [ "Authorization" : "Bearer "+token ]
        
        let partyToMake = PartyToMake(alcoholId: alcoholId, location: location, partyDescription: partyDescription, partyTime: partyTime, partyTitle: partyTime, totalNumberOfMember: totalNumberOfMember)
        
        guard let EncodedUploadData = try? JSONEncoder().encode(partyToMake) else {
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
            
            guard let data = data else {
                print("전달받은 데이터 없음")
                DispatchQueue.main.async {
                    completion(-1)  //error handle !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                }
                return
            }
            
            let decoder:JSONDecoder = JSONDecoder()
            do {
                let decodedResponse:MakePartyResponse = try decoder.decode(MakePartyResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.partyId)
                }
            } catch {
                print("응답 디코딩 실패 헀음 했음")
                print(error.localizedDescription)
                dump(error)
                DispatchQueue.main.async {
                    completion(-1)
                }
            }
            
        })
        task.resume()
    }
}

extension RequestMakePre {
    struct MakePartyResponse: Codable {
        let partyId: Int
    }
    
    struct partyToMake: Codable {
        let alcoholId: Int
        let location: String
        let partyDescription: String
        let partyTime: String
        let partyTitle: String
        let totalNumberOfMember: Int
    }
}
