//
//  Demo_PhotoViewController.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 16..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import UIKit

extension PhotoViewController {
    func handle(image: UIImage) {
        API.requestEmotions(image: image, handler: { [weak self] faces in
            guard let faces = faces else { return }
            let face = faces.first
            
            self?.updateEmotionLabel(emotion: face?.emotion)
            
            let markedImage = image.mark(faces: faces)
            self?.updateImageView(image: markedImage)
            
            self?.saveResult(image: image, faces: faces)
        })
    }
}
