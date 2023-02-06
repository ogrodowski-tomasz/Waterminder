//
//  WaterListViewModel.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 06/02/2023.
//

import Foundation

protocol PlantListViewModelProtocol: AnyObject {
    var delegate: PlantListViewModelDelegate? { get set }
    var dataSource: [String] { get }
    
}

protocol PlantListViewModelDelegate: AnyObject {
    func onGetPlantsSuccess()
    func onGetPlantsFailure(error: Error?)
}
