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
    case imagePicker(
        sourceType: ImagePickerSource,
        delegate: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate)
}

protocol AnyRouter {
    var navigationController: UINavigationController { get set }
    func navigateTo(route: AppRoutes, animated: Bool)
    func present(_ viewController: UIViewController)
    func dismiss(animated: Bool)
    func pop(animated: Bool)
}

class AppRouter: AnyRouter {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func present(_ viewController: UIViewController) {
        navigationController.present(viewController, animated: true)
    }

    func navigateTo(route: AppRoutes, animated: Bool = true) {
        let viewController: UIViewController
        switch route {
        case .addNewPlant(let viewModel):
            viewController = AddPlantViewController(viewModel: viewModel, router: self)
        case .editPlant(let viewModel):
            viewController = EditPlantViewController(viewModel: viewModel, router: self)
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
            viewController = imagePickerController
            present(viewController)
            return
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    func dismiss(animated: Bool = true) {
        navigationController.dismiss(animated: animated)
    }

    func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
}
