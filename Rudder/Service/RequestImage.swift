//
//  RequestImage.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/06.
//

import Foundation
import UIKit

struct RequestImage {
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    static func downloadImage(from url: URL, imageView: UIImageView){
        let cacheKey: String = url.absoluteString
        if let cachedImage = ImageCache.imageCache.object(forKey: cacheKey as NSString) {
            print("already in cache")
            DispatchQueue.main.async {imageView.image = cachedImage}
           
        }
        print("Download Started")
       
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
    
            let image = UIImage(data: data)
            guard image != nil else {return }
            ImageCache.imageCache.setObject(image!, forKey: cacheKey as NSString)
            DispatchQueue.main.async {imageView.image = image! }
        }
    }
}
