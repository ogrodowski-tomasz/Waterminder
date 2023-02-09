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
    var context: NSManagedObjectContext { get }
    func getPlants()
    func addPlant(name: String, overview: String, wateringDate: Date, photo: UIImage) -> NSManagedObjectID?
    func removePlant(id: NSManagedObjectID) -> Bool
    func updatePlant(id: NSManagedObjectID, newName: String, newOverview: String, newWateringDate: Date, newPhoto: UIImage) -> Plant?
}

protocol AnyPlantServiceDelegate: AnyObject {
    func didReceivePlants(plants: [Plant])
    func didReceiveError(error: Error)
}

class PlantService: NSObject, AnyPlantService {

    let context: NSManagedObjectContext

    let fetchedPlantsController: NSFetchedResultsController<Plant>

    weak var delegate: AnyPlantServiceDelegate?

    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context

        fetchedPlantsController = NSFetchedResultsController(
            fetchRequest: Plant.fetchRequest(),
            managedObjectContext: context,
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

    func addPlant(name: String, overview: String, wateringDate: Date, photo: UIImage) -> NSManagedObjectID? {
        let newPlant = Plant(context: context)
        newPlant.name = name
        newPlant.overview = overview
        newPlant.wateringDate = wateringDate
        newPlant.photo = photo
        do {
            try context.save()
            return newPlant.objectID
        } catch {
            delegate?.didReceiveError(error: error)
            return nil
        }
    }

    @discardableResult
    func removePlant(id: NSManagedObjectID) -> Bool {
        if let plant = Plant.byId(id, context: context) {
            context.delete(plant)
            do {
                try context.save()
                return true
            } catch {
                delegate?.didReceiveError(error: error)
            }
        }
        return false
    }

    @discardableResult
    func updatePlant(id: NSManagedObjectID, newName: String, newOverview: String, newWateringDate: Date, newPhoto: UIImage) -> Plant? {
        if let plant = Plant.byId(id, context: context) {
            plant.name = newName
            plant.overview = newOverview
            plant.wateringDate = newWateringDate
            plant.photo = newPhoto
            do {
                try context.save()
                return plant
            } catch {
                delegate?.didReceiveError(error: error)
                return nil
            }
        } else {
            print("DEBUG: no plant with this id")
            return nil
        }
    }

}

extension PlantService: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let plants = controller.fetchedObjects as? [Plant] else { return }
        delegate?.didReceivePlants(plants: plants)
    }
}
