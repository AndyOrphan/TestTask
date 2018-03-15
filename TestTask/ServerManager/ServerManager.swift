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
            return
        }
        var request = URLRequest(url: url)
        
        request.addValue("qqkev4dws7f9q3tvc9mb3hzy", forHTTPHeaderField: "Api-Key")
        
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            guard let resDict = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return
            }
            
            if let array = resDict["images"] as? [[String: Any]] {
                if let first = array.first {
                    if let displaySizes = first["display_sizes"] as? [[String: Any]] {
                        if let thumb = displaySizes.first {
                            if let url = thumb["uri"] as? String {
                                self.downloadImage(with: url, callback: { imageData in
                                    DispatchQueue.main.async {
                                        callback(query, imageData)
                                    }
                                })
                            }
                        }
                    }
                }
            }
            
        }).resume()
        
    }
    
    func downloadImage(with urlStr: String , callback: @escaping (_ imageData: Data)->()) {
        
        let url: URL = URL(string: urlStr)!
        var request = URLRequest(url: url)
        
        request.addValue("qqkev4dws7f9q3tvc9mb3hzy", forHTTPHeaderField: "Api-Key")
        
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            DispatchQueue.main.async {
                //if let image = UIImage(data: data) {
                    callback(data)
                //}
            }
            
        }).resume()
    }
    
}
