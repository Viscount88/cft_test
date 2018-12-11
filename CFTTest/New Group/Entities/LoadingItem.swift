//
//  LoadingItem.swift
//  CFTTest
//
//  Created by Денис Лебедько on 10/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import Foundation

class LoadingItem: NSObject {
    @objc dynamic var currentProgress: Float = 0
    var elapsedTime: Float = 0
    
    func updateProgress(timeInterval: Float, loadingTime: Float) {
        elapsedTime += timeInterval
        currentProgress = elapsedTime/loadingTime * 100
    }
}
