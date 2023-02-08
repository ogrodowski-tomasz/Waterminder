//
//  UIImageExtensionsTests.swift
//  WaterminderTests
//
//  Created by Tomasz Ogrodowski on 08/02/2023.
//

import XCTest
@testable import Waterminder

final class UIImageExtensionsTests: XCTestCase {

    func test_isEqualTo_SameImages_ReturnsTrue() {
        let imageName = "plant"
        guard let image = UIImage(named: imageName) else {
            XCTFail("No such image")
            return
        }

        let result = image.isEqualTo(image: UIImage(named: imageName))

        XCTAssertTrue(result, "Result should be 'true' because both images are the same")
    }

    func test_isEqualTo_DifferentImages_ReturnsFalse() {
        guard let image = UIImage(named: "plant") else {
            XCTFail("No such image")
            return
        }

        let result = image.isEqualTo(image: UIImage(named: "plus_photo"))
        XCTAssertFalse(result, "Result should be 'false' because both images aren't the same")
    }

}
