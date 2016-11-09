//
//  Emotion.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 9..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import Foundation
import ObjectMapper

enum EmotionType {
    case anger(Double)
    case contempt(Double)
    case disgust(Double)
    case fear(Double)
    case happiness(Double)
    case neutral(Double)
    case sadness(Double)
    case surprise(Double)
    
    var emoji: String {
        switch self {
        case .anger(_): return "😡"
        case .contempt(_): return "😖"
        case .disgust(_): return "😒"
        case .fear(_): return "😱"
        case .happiness(_): return "😄"
        case .neutral(_): return "😐"
        case .sadness(_): return "😢"
        case .surprise(_): return "😮"
        }
    }
}

class Emotion: Mappable {
    dynamic var anger = 0.0
    dynamic var contempt = 0.0
    dynamic var disgust = 0.0
    dynamic var fear = 0.0
    dynamic var happiness = 0.0
    dynamic var neutral = 0.0
    dynamic var sadness = 0.0
    dynamic var surprise = 0.0
    
    // MARK: Mapping
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        anger <- map["anger"]
        contempt <- map["contempt"]
        disgust <- map["disgust"]
        fear <- map["fear"]
        happiness <- map["happiness"]
        neutral <- map["neutral"]
        sadness <- map["sadness"]
        surprise <- map["surprise"]
    }
    
    // MARK: Helper
    func findEmotion() -> EmotionType {
        let value = max(anger, contempt, disgust, fear, happiness, neutral, sadness, surprise)
        if value == anger { return .anger(value) }
        else if value == contempt { return .contempt(value) }
        else if value == disgust { return .disgust(value) }
        else if value == fear { return .fear(value) }
        else if value == happiness { return .happiness(value) }
        else if value == neutral { return .neutral(value) }
        else if value == sadness { return .sadness(value) }
        else { return .surprise(value) }
    }
}
