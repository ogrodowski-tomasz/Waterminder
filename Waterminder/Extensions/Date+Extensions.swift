//
//  Date+Extensions.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import Foundation

extension Date {
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }

    static func toDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.timeStyle = .short
        return dateFormatter.date(from: string) ?? Date()
    }
}
