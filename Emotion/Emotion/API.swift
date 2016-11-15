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

enum APIKey {
    static let key1 = "d428f0aa70204c9791d2434931f4633a"
    static let key2 = "33a020613c834ac09aeafd8b84e76945"
    static let key3 = "c3d88264c1614d7e8b4a9f193667db8e"
    static let key4 = "7434ac08d87b410f98c7caed06faff8e"
}

fileprivate struct ImageEncoding: ParameterEncoding {
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

class API {
    class func requestEmotions(image: UIImage, handler: @escaping ([Face]?) -> ()) {
        let url = "https://api.projectoxford.ai/emotion/v1.0/recognize"
        let headers = ["Ocp-Apim-Subscription-Key": APIKey.key1,
                       "Content-Type": "application/octet-stream"]
        
        Alamofire.request(url, method: .post, parameters: Parameters(), encoding: ImageEncoding(image: image), headers: headers)
            .responseArray { (response: DataResponse<[Face]>) in
                switch response.result {
                case .success(let faces):
                    handler(faces)
                case .failure(let error):
                    print(error)
                    handler(nil)
                }
        }
    }
    
    class func detectFaces(photo: Photo, handler: @escaping ([IdentifiableFace]?) -> ()) {
        let url = "https://api.projectoxford.ai/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=false&returnFaceAttributes=age%2Cgender%2CheadPose%2Csmile%2CfacialHair%2Cglasses"
        let headers = ["Ocp-Apim-Subscription-Key": APIKey.key3, "Content-Type": "application/octet-stream",]
        guard let image = photo.image else { return }
        Alamofire.request(url, method: .post, parameters: [:], encoding: ImageEncoding(image: image), headers: headers)
            .responseArray(completionHandler: { (response: DataResponse<[IdentifiableFace]>) in
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
            })
    }
    
    class func groupFaces(faces: [IdentifiableFace], handler: @escaping ([[String]]?, [String]?) -> ()) {
        let url = "https://api.projectoxford.ai/face/v1.0/group"
        let headers = ["Ocp-Apim-Subscription-Key": APIKey.key3, "Content-Type": "application/json"]
        let faceIds = faces.map({ $0.identifier })
        let parameters = ["faceIds": faceIds]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseObject(completionHandler: { (response: DataResponse<FaceGroup>) in
                switch response.result {
                case .success(let value):
                    handler(value.groups, value.messyGroup)
                case .failure(let error):
                    print(error)
                    handler(nil, nil)
                }
            })
    }
}
