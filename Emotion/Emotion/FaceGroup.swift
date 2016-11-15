//
//  FaceGroup.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 15..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import Foundation
import ObjectMapper

class FaceGroup: Mappable {
    var groups: [[String]]?
    var messyGroup: [String]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        groups <- map["groups"]
        messyGroup <- map["messyGroup"]
    }
}
