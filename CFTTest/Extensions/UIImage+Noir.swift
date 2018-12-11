//
//  UIImage+Noir.swift
//  CFTTest
//
//  Created by Денис Лебедько on 06/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

extension UIImage {
    var noir: UIImage {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return self }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        
        return self
    }
}
