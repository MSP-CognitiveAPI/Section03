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

// Microsoft Cognitive Services
// Emotion API Reference
// https://dev.projectoxford.ai/docs/services/5639d931ca73072154c1ce89/operations/563b31ea778daf121cc3a5fa

enum APIKey {
    static let key1 = "d428f0aa70204c9791d2434931f4633a"
    static let key2 = "33a020613c834ac09aeafd8b84e76945"
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
}
