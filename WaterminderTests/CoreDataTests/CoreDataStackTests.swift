//
//  CoreDataStackTests.swift
//  WaterminderTests
//
//  Created by Tomasz Ogrodowski on 08/02/2023.
//

import CoreData
import XCTest

@testable import Waterminder

final class PlantServiceTests: XCTestCase {

    var mockCoreDataStack: MockCoreDataStack!
    var mockPlantServiceDelegate: MockPlantServiceDelegate!
    var plantService: PlantService!

    override func setUp() {
        mockCoreDataStack = MockCoreDataStack()
        mockPlantServiceDelegate = MockPlantServiceDelegate()
        plantService = PlantService(context: mockCoreDataStack.context)
        plantService.delegate = mockPlantServiceDelegate
    }

    override func tearDown() {
        mockCoreDataStack = nil
        plantService.delegate = nil
        plantService = nil
    }

    func test_getPlants() {
        plantService.getPlants()
        XCTAssertTrue(mockPlantServiceDelegate.didReceivedNewPlants)
    }

    func test_addPlant() {
        let numberOfPlantAdded = Int.random(in: 2...100)
        for _ in 0..<numberOfPlantAdded {
            let name = "Default plant"
            let overview = "Default overview"
            let wateringDate = Date()
            let image = UIImage(named: "plant")!
            let newId = plantService.addPlant(
                name: name,
                overview: overview,
                wateringDate: wateringDate,
                photo: image
            )

            XCTAssertNotNil(newId)
            XCTAssertNotNil(
                Plant.byId(
                    newId!,
                    context: mockCoreDataStack.context))
        }

        plantService.getPlants()
        XCTAssertTrue(mockPlantServiceDelegate.didReceivedNewPlants)
        XCTAssertEqual(mockPlantServiceDelegate.receivedPlantsCount, numberOfPlantAdded)
    }

    func test_delegate_SuccessMethodCalled() {
        for _ in 0..<Int.random(in: 1...100) {
            plantService.getPlants()
            XCTAssertTrue(mockPlantServiceDelegate.didReceivedNewPlants)
            mockPlantServiceDelegate.didReceivedNewPlants = false
        }
    }

    func test_updatePlant_correctlyUpdatesPlant() {
        var name = "Default plant"
        var overview = "Default overview"
        var wateringDate = Date()
        var image = UIImage(named: "plant")!
        let plantId = plantService.addPlant(
            name: name,
            overview: overview,
            wateringDate: wateringDate,
            photo: image
        )
        XCTAssertNotNil(plantId)

        name = "New name"
        overview = "New overview"
        wateringDate = Date()
        image = UIImage(named: "plant")!

        let newPlant = plantService.updatePlant(
            id: plantId!,
            newName: name,
            newOverview: overview,
            newWateringDate: wateringDate,
            newPhoto: image)

        XCTAssertNotNil(newPlant)
        XCTAssertEqual(newPlant!.objectID, plantId!)
        XCTAssertEqual(newPlant!.name!, name)
        XCTAssertEqual(newPlant!.overview!, overview)
        XCTAssertEqual(newPlant!.wateringDate!, wateringDate)
        XCTAssertTrue(newPlant!.photo!.isEqualTo(image: image))
    }

    func test_removePlant() {
        let name = "Default plant"
        let overview = "Default overview"
        let wateringDate = Date()
        let image = UIImage(named: "plant")!
        let plantId = plantService.addPlant(
            name: name,
            overview: overview,
            wateringDate: wateringDate,
            photo: image
        )
        XCTAssertNotNil(plantId)

        plantService.getPlants()
        XCTAssertTrue(mockPlantServiceDelegate.didReceivedNewPlants)
        XCTAssertEqual(mockPlantServiceDelegate.receivedPlantsCount, 1)

        let deletionResult = plantService.removePlant(id: plantId!)
        XCTAssertTrue(deletionResult)
    }

}
