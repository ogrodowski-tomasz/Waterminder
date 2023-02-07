//
//  AppRouter.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

enum ImagePickerSource {
    case camera
    case library
}

enum AppRoutes {
    case addNewPlant(viewModel: AnyAddPlantViewModel)
    case editPlant(viewModel: AnyEditPlantViewModel)
    case imagePicker(sourceType: ImagePickerSource, delegate: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate)
}

protocol AnyRouter {
    var navigationController: UINavigationController { get set }
    func navigateTo(route: AppRoutes, animated: Bool)
    func dismiss(animated: Bool)
    func pop(animated: Bool)
}

class AppRouter: AnyRouter {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func navigateTo(route: AppRoutes, animated: Bool = true) {
        let vc: UIViewController
        switch route {
        case .addNewPlant(let viewModel):
            vc = AddPlantViewController(viewModel: viewModel, router: self)
        case .editPlant(let viewModel):
            vc = EditPlantViewController(viewModel: viewModel, router: self)
        case .imagePicker(let sourceType, let delegate):
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = delegate
            imagePickerController.allowsEditing = true
            switch sourceType {
            case .camera:
                imagePickerController.sourceType = .camera
            case .library:
                imagePickerController.sourceType = .photoLibrary
            }
            vc = imagePickerController
            navigationController.present(vc, animated: true)
            return
        }
        navigationController.pushViewController(vc, animated: true)
    }

    func dismiss(animated: Bool = true) {
        navigationController.dismiss(animated: animated)
    }

    func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }




}
