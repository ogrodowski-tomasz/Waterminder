//
//  EditPlantViewModel.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

protocol AnyEditPlantViewModel {
    var plantService: AnyPlantService { get }
    var plant: PlantModel { get }
    var initialName: String { get }
    var initialWateringTime: Date { get }
    var initialOverview: String { get }
    var initialPhoto: UIImage { get }
    func updatePlant(newName: String, newOverview: String, newWateringDate: Date, newPhoto: UIImage)
}

class EditPlantViewModel: AnyEditPlantViewModel {


    var plantService: AnyPlantService
    let plant: PlantModel

    init(plantService: AnyPlantService, plant: PlantModel) {
        self.plantService = plantService
        self.plant = plant
    }

    func updatePlant(newName: String, newOverview: String, newWateringDate: Date, newPhoto: UIImage) {
        plantService.updatePlant(id: plant.id, newName: newName, newOverview: newOverview, newWateringDate: newWateringDate, newPhoto: newPhoto)
    }

    var initialName: String { plant.name }

    var initialWateringTime: Date { Date.toDate(string: plant.wateringDate) }

    var initialOverview: String { plant.overview }

    var initialPhoto: UIImage { plant.photo }

}
