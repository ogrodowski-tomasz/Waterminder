//
//  PlantListViewModelTests.swift
//  WaterminderTests
//
//  Created by Tomasz Ogrodowski on 09/02/2023.
//

import XCTest

@testable import Waterminder

final class PlantListViewModelTests: XCTestCase {

    var mockCoreDataStack: MockCoreDataStack!
    var plantService: AnyPlantService!
    var plantListViewModel: AnyPlantListViewModel!
    var mockPlantListViewModelDelegate: MockPlantListViewModelDelegate!

    override func setUp() {
        mockCoreDataStack = MockCoreDataStack()
        plantService = PlantService(
            context: mockCoreDataStack.context
        )
        plantListViewModel = PlantListViewModel(
            plantService: plantService,
            notificationsService: UserNotificationsService()
        )
        mockPlantListViewModelDelegate = MockPlantListViewModelDelegate()
        plantListViewModel.delegate = mockPlantListViewModelDelegate
    }

    override func tearDown() {
        mockCoreDataStack = nil
        plantService = nil
        plantListViewModel = nil
        mockPlantListViewModelDelegate = nil
    }

    func test_plantServiceDelegate_SuccessfullySetUp() {
        XCTAssertNotNil(plantService.delegate)
    }

    func test_getPlants_firesDelegate() {
        // When
        plantListViewModel.getPlants()

        // Then
        XCTAssertTrue(mockPlantListViewModelDelegate.plantsReceived)
        XCTAssertFalse(mockPlantListViewModelDelegate.errorReceived)
        XCTAssertTrue(mockPlantListViewModelDelegate.errorMessage.isEmpty)
    }

    func test_removingPlant() {
        // given
        let name = "Default name"
        let overview = "Default overview"
        let wateringDate = Date()
        guard let photo = UIImage(named: "plant") else {
            XCTFail()
            return
        }
        let _ = plantService.addPlant(name: name, overview: overview, wateringDate: wateringDate, photo: photo)

        // When
        plantListViewModel.getPlants()

        // Then
        XCTAssertEqual(plantListViewModel.plants.count, 1)
        XCTAssertTrue(mockPlantListViewModelDelegate.plantsReceived)
    }

}
