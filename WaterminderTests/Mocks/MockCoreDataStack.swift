//
//  MockCoreDataStack.swift
//  WaterminderTests
//
//  Created by Tomasz Ogrodowski on 08/02/2023.
//

import CoreData
import Foundation

@testable import Waterminder

class MockCoreDataStack {
    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    init() {
        ValueTransformer.setValueTransformer(
            UIImageTransformer(),
            forName: NSValueTransformerName("UIImageTransformer"))
        persistentContainer = NSPersistentContainer(name: "PlantContainer")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType

        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load store! \(error)")
            }
        }
    }

}
