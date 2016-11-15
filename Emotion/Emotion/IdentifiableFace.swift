//
//  IdentifiableFace.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 15..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class IdentifiableFace: Object, Mappable, RealmWriteable {
    dynamic var identifier = ""
    dynamic var faceRect: FaceRect?
    private let photos = LinkingObjects(fromType: Photo.self, property: "identifiableFaces")
    
    var photo: Photo? {
        return photos.first
    }
    
    override class func primaryKey() -> String {
        return "identifier"
    }
    
    // MARK: Mapping
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        identifier <- map["faceId"]
        faceRect <- map["faceRectangle"]
    }
}
