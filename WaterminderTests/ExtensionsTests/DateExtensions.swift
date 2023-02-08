//
//  DateExtensions.swift
//  WaterminderTests
//
//  Created by Tomasz Ogrodowski on 08/02/2023.
//

import XCTest
@testable import Waterminder

final class DateExtensions: XCTestCase {

    func test_date_toString() {
        var mockDate = makeTime(hour: 1, minute: 50)
        var mockString = mockDate.toString
        XCTAssertEqual(mockString, "01:50")

        mockDate = makeTime(hour: 10, minute: 5)
        mockString = mockDate.toString
        XCTAssertEqual(mockString, "10:05")

        mockDate = makeTime(hour: 22, minute: 45)
        mockString = mockDate.toString
        XCTAssertEqual(mockString, "22:45")

        mockDate = makeTime(hour: 0, minute: 0)
        mockString = mockDate.toString
        XCTAssertEqual(mockString, "00:00")

        mockDate = makeTime(hour: 24, minute: 0)
        mockString = mockDate.toString
        XCTAssertEqual(mockString, "00:00")
    }

    func makeTime(hour: Int, minute: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        guard let date = calendar.date(from: components) else {
            return Date()
        }
        return date
    }

    func test_date_fromString() {
        for _ in 1...100 {
            let randomHour = Int.random(in: 0..<24)
            let randomMinute = Int.random(in: 0..<60)

            let testDate = makeTime(hour: randomHour, minute: randomMinute)
            let testComponents = getHourMinute(date: testDate)
            let mockDate = Date.from(string: "\(randomHour):\(randomMinute)")
            let mockComponents = getHourMinute(date: mockDate)

            XCTAssertEqual(testComponents.hour, mockComponents.hour)
            XCTAssertEqual(testComponents.minute, mockComponents.minute)
        }

    }

    func getHourMinute(date: Date) -> (hour: Int, minute: Int) {
        let components = Calendar.current.dateComponents(in: .current, from: date)
        return (components.hour!, components.minute!)
    }

}
