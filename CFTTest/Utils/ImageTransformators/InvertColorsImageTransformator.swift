//
//  InvertColorsImageTransformator.swift
//  CFTTest
//
//  Created by Денис Лебедько on 05/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

class InvertColorsImageTransformator: ImageTransformator {
    
    override func transform(_ image: UIImage, progressBlock: @escaping (Float) -> Void, completionBlock: @escaping (UIImage) -> Void) {
        
        waitForAsyncOperation(progressBlock: progressBlock) {
            completionBlock(image.noir)
        }
        
    }
}
