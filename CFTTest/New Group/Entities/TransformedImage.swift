//
//  TransformedImage.swift
//  CFTTest
//
//  Created by Денис Лебедько on 10/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

struct TransformedImage {
    let image: UIImage
    let uuid: String
    
    init(image: UIImage, uuid: String) {
        self.image = image
        self.uuid = uuid
    }
}

extension TransformedImage: Equatable {
    static func ==(lhs: TransformedImage, rhs: TransformedImage) -> Bool {
        let areEqual = lhs.uuid == rhs.uuid &&
            lhs.image == rhs.image
        
        return areEqual
    }
}
