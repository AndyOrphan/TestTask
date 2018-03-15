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
    
    let mainUrl = "https://api.gettyimages.com/v3/search/images?fields=thumb&sort_order=best&phrase=cat"
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func testConnection() {
        let url: URL = URL(string: mainUrl)!
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
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            
            print(json)
            
        }).resume()
        
    }
    
    func testDownloadImage(callback: @escaping (_ image: UIImage)->()) {
        let testUrlStr = "https://media.gettyimages.com/photos/lovely-kitten-on-sleeping-picture-id855294686?b=1&k=6&m=855294686&s=170x170&h=ZFkni97Kv6zou2jXMYcmyvVpALv9j0caTIWb6faqc5o="
        
        let url: URL = URL(string: testUrlStr)!
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
                if let image = UIImage(data: data) {
                    callback(image)
                }
            }
            
        }).resume()
    }
    
}
