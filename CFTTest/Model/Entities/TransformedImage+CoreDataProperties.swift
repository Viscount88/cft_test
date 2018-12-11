//
//  TransformedImage+CoreDataProperties.swift
//  CFTTest
//
//  Created by Александр Лебедько on 10/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//
//

import Foundation
import CoreData


extension TransformedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransformedImage> {
        return NSFetchRequest<TransformedImage>(entityName: "TransformedImage")
    }

    @NSManaged public var imageData: NSData?

}
