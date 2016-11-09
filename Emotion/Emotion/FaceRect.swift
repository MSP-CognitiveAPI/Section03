//
//  FaceRect.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 9..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import Foundation
import ObjectMapper

class FaceRect: Mappable {
    dynamic var top = 0.0
    dynamic var left = 0.0
    dynamic var width = 0.0
    dynamic var height = 0.0
    
    var cgRect: CGRect {
        return CGRect(x: left, y: top, width: width, height: height)
    }
    
    // MARK: Mapping
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        top <- map["top"]
        left <- map["left"]
        width <- map["width"]
        height <- map["height"]
    }
}
