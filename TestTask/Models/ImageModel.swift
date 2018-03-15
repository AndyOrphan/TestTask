//
//  ImageModel.swift
//  TestTask
//
//  Created by Orphan on 3/15/18.
//  Copyright © 2018 Orphan. All rights reserved.
//

import UIKit
import RealmSwift

class ImageModel: Object {
    
    @objc dynamic var searchWord: String!
    @objc dynamic var downloadedImage: Data!
    @objc dynamic var date: Date!
    
}
