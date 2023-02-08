//
//  CoreDataStack.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 06/02/2023.
//

import CoreData
import Foundation

class CoreDataStack {
    let persistentContainer: NSPersistentContainer

    static let shared = CoreDataStack()

    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

    init() {
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        persistentContainer = NSPersistentContainer(name: "PlantContainer")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Error initializing Core Data: \(error)")
            }
        }
    }

    func saveContext() {
        do {
            try viewContext.save()
            print("DEBUG: Successfully saved context")
        } catch {
            fatalError("Unresolved error: \(error)")
        }
    }
}
