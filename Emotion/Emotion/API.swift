//
//  API.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 9..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RealmSwift

// Microsoft Cognitive Services
// Emotion API Reference
// https://dev.projectoxford.ai/docs/services/5639d931ca73072154c1ce89/operations/563b31ea778daf121cc3a5fa

struct ImageEncoding: ParameterEncoding {
    private let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        urlRequest?.httpBody = imageData
        return urlRequest!
    }
}

extension API {
    class func handleRequestEmotions(response: DataResponse<[Face]>, handler: @escaping ([Face]?) -> ()) {
        switch response.result {
        case .success(let faces):
            handler(faces)
        case .failure(let error):
            print(error)
            handler(nil)
        }
    }
    
    class func handleDetectFaces(photo: Photo, response: DataResponse<[IdentifiableFace]>, handler: @escaping ([IdentifiableFace]?) -> ()) {
        switch response.result {
        case .success(let faces):
            for face in faces {
                face.update()
            }
            let realm = try? Realm()
            realm?.beginWrite()
            realm?.delete(photo.identifiableFaces)
            photo.identifiableFaces.append(objectsIn: faces)
            try? realm?.commitWrite()
            handler(faces)
        case .failure(let error):
            print(error)
            handler(nil)
        }
    }
    
    class func handleGroupFaces(response: DataResponse<FaceGroup>, handler: @escaping ([[String]]?, [String]?) -> ()) {
        switch response.result {
        case .success(let value):
            handler(value.groups, value.messyGroup)
        case .failure(let error):
            print(error)
            handler(nil, nil)
        }
    }
}
