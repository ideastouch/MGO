//
//  MainSceneCollectionViewCell.swift
//  mgoclient
//
//  Created by Gustavo Halperin on 9/25/14.
//  Copyright (c) 2014 mgo. All rights reserved.
//

import Foundation
import UIKit

class MainSceneCollectionViewCell: UICollectionViewCell {
    var _properties:NSDictionary = NSDictionary() {
        didSet {
            if _properties.allKeys.count > 0 {
                var imageName:String =  _properties.objectForKey("icon") as String
                _imageView.image = UIImage(named: imageName)
            }
        }
    }
    @IBOutlet weak var _imageView: UIImageView!
    
}