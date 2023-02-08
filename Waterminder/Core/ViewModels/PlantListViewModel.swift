//
//  PlantListViewModel.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 06/02/2023.
//

import UIKit

protocol AnyPlantListViewModel {
    var plantService: AnyPlantService { get }
    var notificationsService: AnyUserNotificationsService { get }
    var delegate: AnyPlantViewModelDelegate? { get set }
    var plants: [PlantModel] { get set }
    func removePlant(at index: Int)
    func getPlants()
}

protocol AnyPlantViewModelDelegate: AnyObject {
    func didReceivePlants()
    func didReceiveError(error: Error)
}

class PlantListViewModel: AnyPlantListViewModel {
    var plants = [PlantModel]()

    var notificationsService: AnyUserNotificationsService

    weak var delegate: AnyPlantViewModelDelegate?

    private(set) var plantService: AnyPlantService

    init(
        plantService: AnyPlantService,
        notificationsService: AnyUserNotificationsService
    ) {
        self.plantService = plantService
        self.notificationsService = notificationsService
        setupService()
        getPlants()
    }

    func setupService() {
        plantService.delegate = self
    }

    func getPlants() {
        plantService.getPlants()
    }

    func removePlant(at index: Int) {
        let plant = plants[index]
        plantService.removePlant(id: plant.id)
        notificationsService.removeNotification(id: plant.id)
    }

}

extension PlantListViewModel: AnyPlantServiceDelegate {
    func didReceivePlants(plants: [Plant]) {
        self.plants = plants.map(PlantModel.init)
        delegate?.didReceivePlants()
    }

    func didReceiveError(error: Error) {
        delegate?.didReceiveError(error: error)
    }


}
