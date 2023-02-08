//
//  NSManagedObjectID+Extensions.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 08/02/2023.
//

import CoreData

extension NSManagedObjectID {
    var toString: String {
        String(format: "%@", self)
    }
}
