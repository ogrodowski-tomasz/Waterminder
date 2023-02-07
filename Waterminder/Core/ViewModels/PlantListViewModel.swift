//
//  PlantListViewModel.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 06/02/2023.
//

import UIKit

protocol AnyPlantListViewModel {
    var plantService: AnyPlantService { get }
    var delegate: AnyPlantViewModelDelegate? { get set }
    var plants: [PlantModel] { get set }
    func removePlant(at index: Int)

}

protocol AnyPlantViewModelDelegate: AnyObject {
    func didReceivePlants()
    func didReceiveError(error: Error)
}

class PlantListViewModel: AnyPlantListViewModel {
    var plants = [PlantModel]()

    weak var delegate: AnyPlantViewModelDelegate?

    private(set) var plantService: AnyPlantService

    init(plantService: AnyPlantService) {
        self.plantService = plantService
        setupService()
    }

    func setupService() {
        plantService.delegate = self
        plantService.getPlants()
    }

    func removePlant(at index: Int) {

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
