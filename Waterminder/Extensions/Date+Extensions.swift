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
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale.init(identifier: "pl_PL")
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }

    static func from(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale.init(identifier: "pl_PL")
        dateFormatter.timeStyle = .short
        return dateFormatter.date(from: string) ?? Date()
    }
}
