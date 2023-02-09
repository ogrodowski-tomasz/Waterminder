//
//  EditPlantViewModel.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

protocol AnyEditPlantViewModel {
    var plantService: AnyPlantService { get }
    var notificationsService: AnyUserNotificationsService { get }
    var plant: PlantModel { get }
    var initialName: String { get }
    var initialWateringTime: Date { get }
    var initialOverview: String { get }
    var initialPhoto: UIImage { get }
    func updatePlant(newName: String, newOverview: String, newWateringDate: Date, newPhoto: UIImage)
}

class EditPlantViewModel: AnyEditPlantViewModel {

    var plantService: AnyPlantService
    var notificationsService: AnyUserNotificationsService
    let plant: PlantModel

    init(
        plantService: AnyPlantService,
        notificationsService: AnyUserNotificationsService,
        plant: PlantModel
    ) {
        self.plantService = plantService
        self.notificationsService = notificationsService
        self.plant = plant
    }

    func updatePlant(newName: String, newOverview: String, newWateringDate: Date, newPhoto: UIImage) {
        _ = plantService.updatePlant(
            id: plant.id,
            newName: newName,
            newOverview: newOverview,
            newWateringDate: newWateringDate,
            newPhoto: newPhoto)
        notificationsService.updateNotification(id: plant.id, newTitle: newName, newTriggerDate: newWateringDate)
    }

    var initialName: String { plant.name }

    var initialWateringTime: Date { Date.from(string: plant.wateringDate) }

    var initialOverview: String { plant.overview }

    var initialPhoto: UIImage { plant.photo }

}
