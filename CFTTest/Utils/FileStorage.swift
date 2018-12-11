//
//  KeyframeStorage.swift
//  CFTTest
//
//  Created by Денис Лебедько on 11/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

class FileStorage {
    
    let fileManager = FileManager.default
    
    func saveImageToFile(image: UIImage) -> String {
        let imageData = NSData(data: image.jpegData(compressionQuality: 1.0)!)
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,  FileManager.SearchPathDomainMask.userDomainMask, true)
        let docs = paths[0] as NSString
        let uuid = NSUUID().uuidString + ".jpeg"
        let fullPath = docs.appendingPathComponent(uuid)
        _ = imageData.write(toFile: fullPath, atomically: true)
        return uuid
    }
    
    func getImagesFromFiles(imageNames: [String]) -> [TransformedImage] {
        
        var savedImages: [TransformedImage] = [TransformedImage]()
        
        for imageName in imageNames {
            if let imagePath = getFilePath(fileName: imageName) {
                if let image = UIImage(contentsOfFile: imagePath) {
                    let transformedImage = TransformedImage(image: image, uuid: imageName)
                    savedImages.append(transformedImage)
                }
            }
        }
        
        return savedImages
    }
    
    func removeImageFromFiles(imageName: String) {
        if let imagePath = getFilePath(fileName: imageName) {
            do {
                try fileManager.removeItem(atPath: imagePath)
            }
            catch let error as NSError {
                print("Image removing error", error)
            }
        }
    }
    
    func getFilePath(fileName: String) -> String? {
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        var filePath: String?
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if paths.count > 0 {
            let dirPath = paths[0] as NSString
            filePath = dirPath.appendingPathComponent(fileName)
        }
        else {
            filePath = nil
        }
        
        return filePath
    }
}
