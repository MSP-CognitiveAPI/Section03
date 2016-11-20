//
//  Demo_API.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 16..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RealmSwift

// Microsoft Cognitive Services
// Emotion API Reference
// https://dev.projectoxford.ai/docs/services/5639d931ca73072154c1ce89/operations/563b31ea778daf121cc3a5fa

class API {
    class func requestEmotions(image: UIImage, handler: @escaping ([Face]?) -> ()) {
        
    }
    
    class func detectFaces(photo: Photo, handler: @escaping ([IdentifiableFace]?) -> ()) {
        
    }
    
    class func groupFaces(faces: [IdentifiableFace], handler: @escaping ([[String]]?, [String]?) -> ()) {
        
    }
}
