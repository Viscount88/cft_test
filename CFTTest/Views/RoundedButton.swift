//
//  RoundedButton.swift
//  CFTTest
//
//  Created by Денис Лебедько on 05/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    @IBInspectable
    var enableRounding: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if enableRounding {
            layer.cornerRadius = min(bounds.height, bounds.width) / 2
        } else {
            layer.cornerRadius = 0
        }
    }
}
