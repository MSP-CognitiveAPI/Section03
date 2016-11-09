//
//  FaceEmotion.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 9..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import Foundation
import ObjectMapper

class Face: Mappable {
    var faceRect: FaceRect?
    var emotion: Emotion?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        faceRect <- map["faceRectangle"]
        emotion <- map["scores"]
    }
}
