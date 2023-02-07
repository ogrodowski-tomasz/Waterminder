//
//  AddPlantViewModel.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

protocol AnyAddPlantViewModel {
    var plantService: AnyPlantService { get }
    func addPlant(name: String, overview: String, wateringDate: Date, photo: UIImage)
}

class AddPlantViewModel: AnyAddPlantViewModel {
    var plantService: AnyPlantService

    init(plantService: AnyPlantService) {
        self.plantService = plantService
    }

    func addPlant(name: String, overview: String, wateringDate: Date, photo: UIImage) {
        plantService.addPlant(name: name, overview: overview, wateringDate: wateringDate, photo: photo)
    }


}
