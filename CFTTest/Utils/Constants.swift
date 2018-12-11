//
//  Constants.swift
//  CFTTest
//
//  Created by Денис Лебедько on 05/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import Foundation

struct Constants {
    
    public static let moduleName = NSStringFromClass(AppDelegate.self)
        .components(separatedBy: ".").first!
    
    public static let transformedImageNamesKey = "TransormedImageNames"
}
