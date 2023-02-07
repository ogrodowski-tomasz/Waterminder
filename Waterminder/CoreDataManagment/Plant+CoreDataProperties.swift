//
//  Plant+CoreDataProperties.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 06/02/2023.
//

import CoreData
import UIKit

@objc(Plant)
public class Plant: NSManagedObject { }

extension Plant {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "wateringDate", ascending: true)]
        return fetchRequest
    }

    @NSManaged public var name: String?
    @NSManaged public var overview: String?
    @NSManaged public var photo: UIImage?
    @NSManaged public var wateringDate: Date?

}

