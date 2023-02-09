//
//  MockPlantServiceDelegate.swift
//  WaterminderTests
//
//  Created by Tomasz Ogrodowski on 08/02/2023.
//

import Foundation

@testable import Waterminder

class MockPlantServiceDelegate: AnyPlantServiceDelegate {

    var didReceivedNewPlants = false
    var receivedPlantsCount = 0
    func didReceivePlants(plants: [Waterminder.Plant]) {
        didReceivedNewPlants = true
        receivedPlantsCount = plants.count
    }

    var errorReceived = false
    func didReceiveError(error: Error) {
        errorReceived = true
    }


}
