//
//  FaceEmotion.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 9..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Face: Object, Mappable, RealmWriteable {
    dynamic var identifier = UUID().uuidString
    dynamic var faceRect: FaceRect?
    dynamic var emotion: Emotion?
    private let photos = LinkingObjects(fromType: Photo.self, property: "faces")
    
    var photo: Photo? {
        return photos.first
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        faceRect <- map["faceRectangle"]
        emotion <- map["scores"]
    }
    
    override class func primaryKey() -> String {
        return "identifier"
    }
}
