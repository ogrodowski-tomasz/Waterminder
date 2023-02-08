//
//  AddPlantViewModel.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

protocol AnyAddPlantViewModel {
    var plantService: AnyPlantService { get }
    var notificationsService: AnyUserNotificationsService { get }
    func addPlant(name: String, overview: String, wateringDate: Date, photo: UIImage)
}

class AddPlantViewModel: AnyAddPlantViewModel {
    var plantService: AnyPlantService

    var notificationsService: AnyUserNotificationsService

    init(
        plantService: AnyPlantService,
        notificationsService: AnyUserNotificationsService
    ) {
        self.plantService = plantService
        self.notificationsService = notificationsService
    }

    func addPlant(name: String, overview: String, wateringDate: Date, photo: UIImage) {
        let id = plantService.addPlant(name: name, overview: overview, wateringDate: wateringDate, photo: photo)
        notificationsService.scheduleNotification(id: id, title: name, triggerDate: wateringDate)
    }


}
