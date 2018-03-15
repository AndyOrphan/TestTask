//
//  ServerManager.swift
//  TestTask
//
//  Created by Orphan on 3/15/18.
//  Copyright © 2018 Orphan. All rights reserved.
//

import UIKit

class ServerManager: NSObject {
    
    static let shared = ServerManager()
    
    let mainUrl = "https://api.gettyimages.com/v3/search/images?fields=thumb&sort_order=best&phrase="
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func searchImage(with query: String, callback: @escaping (_ name: String, _ image: Data) -> ()) {
        guard let url: URL = URL(string: mainUrl + query) else {
            self.postErrorNotification(error: "No Results")
            return
        }
        var request = URLRequest(url: url)
        
        request.addValue("qqkev4dws7f9q3tvc9mb3hzy", forHTTPHeaderField: "Api-Key")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                self.postErrorNotification(error: error?.localizedDescription ?? "No Results")
                return
            }
            guard let data = data else {
                self.postErrorNotification(error: "No Results")
                return
            }
            do {
                guard let resDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    self.postErrorNotification(error: "No Results")
                    return
                }
                guard let array = resDict["images"] as? [[String: Any]] else {
                    self.postErrorNotification(error: "No Results")
                    return
                }
                guard  let first = array.first else {
                    self.postErrorNotification(error: "No Results")
                    return
                }
                guard let displaySizes = first["display_sizes"] as? [[String: Any]] else {
                    self.postErrorNotification(error: "No Results")
                    return
                }
                guard let thumb = displaySizes.first else {
                    self.postErrorNotification(error: "No Results")
                    return
                }
                if let url = thumb["uri"] as? String {
                    self.downloadImage(with: url, callback: { imageData in
                        DispatchQueue.main.async {
                            callback(query, imageData)
                        }
                    })
                } else {
                    self.postErrorNotification(error: "No Results")
                }
            } catch {
                self.postErrorNotification(error: "No Results")
            }
            
            
        }).resume()
        
    }
    
    func downloadImage(with urlStr: String , callback: @escaping (_ imageData: Data)->()) {
        
        let url: URL = URL(string: urlStr)!
        var request = URLRequest(url: url)
        
        request.addValue("qqkev4dws7f9q3tvc9mb3hzy", forHTTPHeaderField: "Api-Key")
        
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                self.postErrorNotification(error: "Invalid Image")
                return
            }
            guard let data = data else {
                self.postErrorNotification(error: "Invalid Image")
                return
            }
            
            DispatchQueue.main.async {
                callback(data)
            }
            
        }).resume()
    }
    
    func postErrorNotification(error: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Consts.errorNotificationName), object: nil, userInfo: ["errorStr":error])
    }
}
