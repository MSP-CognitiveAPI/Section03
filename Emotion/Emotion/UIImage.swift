//
//  UIImage.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 9..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import UIKit

extension UIImage {
    func crop(rect: CGRect) -> UIImage? {
        guard let imageRef = self.cgImage?.cropping(to: rect) else { return nil }
        let croppedImage = UIImage(cgImage:imageRef)
        return croppedImage
    }
    
    func scale(width newWidth: CGFloat) -> UIImage {
        guard size.width > newWidth else {
            return self
        }
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func mark(faces: [Face]?, showRect: Bool = true, showEmoji: Bool = true, showImage: Bool = true) -> UIImage? {
        guard let faces = faces else { return self }
        var image: UIImage? = self
        for face in faces {
            image = image?.mark(face: face, showRect: showRect, showEmoji: showEmoji, showImage: showImage)
        }
        return image
    }
    
    func mark(face: Face, showRect: Bool = true, showEmoji: Bool = true, showImage: Bool = true) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        if showImage == true {
            draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        if showRect == true {
            guard let rect = face.faceRect?.cgRect else { return self }
            context.setFillColor(UIColor.clear.cgColor)
            context.setStrokeColor(UIColor.red.cgColor)
            context.setLineWidth(9)
            context.beginPath()
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.closePath()
            context.drawPath(using: CGPathDrawingMode.stroke)
        }
        
        if showEmoji == true {
            guard let emoji = face.emotion?.findEmotion().emoji else { return self }
            guard let rect = face.faceRect?.cgRect else { return self }
            let label = UILabel()
            label.text = emoji
            
            var fontSize: CGFloat = 200
            while (emoji as NSString).size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)]).width > rect.width {
                fontSize -= 10
            }
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.sizeToFit()
            let newRect = CGRect(x: rect.origin.x, y: rect.origin.y - rect.height, width: rect.width, height: rect.height)
            label.drawHierarchy(in: newRect, afterScreenUpdates: true)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
