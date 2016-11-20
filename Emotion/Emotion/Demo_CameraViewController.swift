//
//  Demo_CameraViewController.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 16..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import UIKit

extension CameraViewController {
    func handle(image: UIImage) {
        frameGrabCounter += 1
        if self.frameGrabCounter % 120 == 0 { // 40 per sec on iPhone 6s; 20 API calls available per minute
            OperationQueue.main.addOperation { [weak self] in
                self?.imageView.image = nil
                API.requestEmotions(image: image, handler: { (faces) in
                    guard let faces = faces else { return }
                    var string = ""
                    for face in faces {
                        guard let emoji = face.emotion?.findEmotion().emoji else { continue }
                        string += emoji
                        string += "\n"
                    }
                    let overlayImage = image.mark(faces: faces, showImage: false)
                    self?.update(image: overlayImage)
                    
                    self?.saveResult(image: image, faces: faces)
                })
            }
        }
    }
}
