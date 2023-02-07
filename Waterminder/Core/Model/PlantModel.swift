//
//  PlantModel.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 06/02/2023.
//

import UIKit

struct PlantModel {
    let plant: Plant
    var name: String { plant.name ?? "N/A" }
    var description: String { plant.overview ?? "N/A" }
    var photo: UIImage { plant.photo ?? UIImage(systemName: "questionmark.diamond.fill")! }
    var wateringDate: Date { plant.wateringDate ?? Date() }
}
