//
//  PlantModel.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 06/02/2023.
//

import CoreData
import UIKit

struct PlantModel {
    let plant: Plant
    var id: NSManagedObjectID { plant.objectID }
    var name: String { plant.name ?? "N/A" }
    var overview: String { plant.overview ?? "N/A" }
    var photo: UIImage { plant.photo ?? UIImage(systemName: "questionmark.diamond.fill")! }
    var wateringDate: String { (plant.wateringDate ?? Date()).toString }
}
