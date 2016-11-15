//
//  Photo.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 12..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import Foundation
import RealmSwift
import SDWebImage

class Photo: Object, RealmWriteable {
    dynamic var identifier = UUID().uuidString
    let faces = List<Face>()
    let identifiableFaces = List<IdentifiableFace>()
    
    var image: UIImage? {
        get {
            return SDImageCache.shared().imageFromDiskCache(forKey: identifier)
        }
        set {
            if newValue == nil {
                SDImageCache.shared().removeImage(forKey: identifier)
            } else {
                SDImageCache.shared().store(newValue, forKey: identifier)
            }
        }
    }
    
    override class func primaryKey() -> String {
        return "identifier"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["image"]
    }
}
