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
    
    func mark(rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
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
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
