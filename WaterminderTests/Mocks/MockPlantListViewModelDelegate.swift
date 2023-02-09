//
//  MockPlantListViewModelDelegate.swift
//  WaterminderTests
//
//  Created by Tomasz Ogrodowski on 09/02/2023.
//

import Foundation
@testable import Waterminder

class MockPlantListViewModelDelegate: AnyPlantViewModelDelegate {

    var plantsReceived = false
    func didReceivePlants() {
        plantsReceived = true
    }

    var errorReceived = false
    var errorMessage = ""
    func didReceiveError(error: Error) {
        errorReceived = true
        errorMessage = error.localizedDescription
    }
}
