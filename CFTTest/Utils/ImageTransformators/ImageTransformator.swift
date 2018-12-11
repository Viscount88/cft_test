//
//  ImageTransformator.swift
//  CFTTest
//
//  Created by Денис Лебедько on 05/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

let asyncImageOperationDuration: Float = 0.1

class AsyncImageOperation: Operation {
    
    override func main() {
        Thread.sleep(forTimeInterval: TimeInterval(asyncImageOperationDuration))
    }
}

class ImageTransformator {
    
    private(set) var id: String
    let queue = OperationQueue()
    
    init() {
        id = NSUUID().uuidString
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .background
    }
    
    func waitForAsyncOperation(progressBlock: @escaping (Float) -> Void, completionBlock: @escaping () -> Void) {
            let loadingTime = Float(arc4random_uniform(25) + 5)
            
            let operationsCount = Int(loadingTime/asyncImageOperationDuration)
            var processedOperations: Int = 0
            var operations: [Operation] = []
            
            for _ in 0...operationsCount {
                let operation = AsyncImageOperation()
                
                operation.completionBlock = {
                    processedOperations = processedOperations + 1

                    let progress = Float(processedOperations)/Float(operationsCount)
                    DispatchQueue.main.async {
                        progressBlock(progress)
                    }
                    
                    if processedOperations == operationsCount {
                        DispatchQueue.main.async {
                            completionBlock()
                        }
                    }
                }
                
                operations.append(operation)
            }
            
            self.queue.addOperations(operations, waitUntilFinished: false)
    }
    
    func transform(_ image: UIImage, progressBlock: @escaping (Float) -> Void, completionBlock: @escaping (UIImage) -> Void) {
        fatalError("Must Override")
    }
}

extension ImageTransformator: Equatable {
    
    static func == (lhs: ImageTransformator, rhs: ImageTransformator) -> Bool {
        return lhs.id == rhs.id
    }
    
}

extension Array where Element: ImageTransformator {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
