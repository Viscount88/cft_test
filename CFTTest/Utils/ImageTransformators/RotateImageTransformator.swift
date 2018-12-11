//
//  RotateImageTransformator.swift
//  CFTTest
//
//  Created by Денис Лебедько on 05/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

class RotateImageTransformator: ImageTransformator {

    override func transform(_ image: UIImage, progressBlock: @escaping (Float) -> Void, completionBlock: @escaping (UIImage) -> Void) {
        
        waitForAsyncOperation(progressBlock: progressBlock) {
            let rotatedView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            let transform: CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            rotatedView.transform = transform
            let rotatedSize: CGSize = rotatedView.frame.size
            UIGraphicsBeginImageContextWithOptions(rotatedSize, false, UIScreen.main.scale)
            let bitmap: CGContext = UIGraphicsGetCurrentContext()!
            bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
            bitmap.rotate(by: (CGFloat.pi/2))
            bitmap.scaleBy(x: 1.0, y: -1.0)
            bitmap.draw(image.cgImage!, in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
            let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            completionBlock(newImage)
        }
    }
}
