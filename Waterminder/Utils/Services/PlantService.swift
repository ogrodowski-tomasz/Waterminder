//
//  PlantService.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 06/02/2023.
//

import CoreData
import UIKit

protocol AnyPlantService {
    var delegate: AnyPlantServiceDelegate? { get set }
    var fetchedPlantsController: NSFetchedResultsController<Plant> { get }
    func getPlants()
    func addPlant(name: String, overview: String, wateringDate: Date, photo: UIImage) -> NSManagedObjectID
    func removePlant(id: NSManagedObjectID)
    func updatePlant(id: NSManagedObjectID, newName: String, newOverview: String, newWateringDate: Date, newPhoto: UIImage)
}

protocol AnyPlantServiceDelegate: AnyObject {
    func didReceivePlants(plants: [Plant])
    func didReceiveError(error: Error)
}

class PlantService: NSObject, AnyPlantService {

    let coreDataStack: CoreDataStack

    let fetchedPlantsController: NSFetchedResultsController<Plant>

    weak var delegate: AnyPlantServiceDelegate?

    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack

        fetchedPlantsController = NSFetchedResultsController(
            fetchRequest: Plant.fetchRequest(),
            managedObjectContext: coreDataStack.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        super.init()
        fetchedPlantsController.delegate = self
    }

    func getPlants() {
        do {
            try fetchedPlantsController.performFetch()
            guard let plants = fetchedPlantsController.fetchedObjects else { return }
            delegate?.didReceivePlants(plants: plants)
        } catch {
            print("DEBUG: Failed to fetch plants: \(error)")
            delegate?.didReceiveError(error: error)
        }
    }

    func addPlant(name: String, overview: String, wateringDate: Date, photo: UIImage) -> NSManagedObjectID {
        let newPlant = Plant(context: coreDataStack.viewContext)
        newPlant.name = name
        newPlant.overview = overview
        newPlant.wateringDate = wateringDate
        newPlant.photo = photo
        coreDataStack.saveContext()
        return newPlant.objectID
    }

    func removePlant(id: NSManagedObjectID) {
        if let plant = Plant.byId(id, context: coreDataStack.viewContext) {
            coreDataStack.viewContext.delete(plant)
            coreDataStack.saveContext()
        }
    }

    func updatePlant(id: NSManagedObjectID, newName: String, newOverview: String, newWateringDate: Date, newPhoto: UIImage) {
        if let plant = Plant.byId(id, context: coreDataStack.viewContext) {
            plant.name = newName
            plant.overview = newOverview
            plant.wateringDate = newWateringDate
            plant.photo = newPhoto
            coreDataStack.saveContext()
        } else {
            print("DEBUG: no plant with this id")
        }
    }

}

extension PlantService: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let plants = controller.fetchedObjects as? [Plant] else { return }
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.didReceivePlants(plants: plants)
        }
    }
}
