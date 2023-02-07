//
//  AppDelegate.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 06/02/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()



        let navigationController = UINavigationController()
        let router: AnyRouter = AppRouter(navigationController: navigationController)
        let plantListVC = PlantListViewController(
            plantListViewModel: PlantListViewModel(plantService: PlantService()),
            router: router)
        navigationController.viewControllers = [plantListVC]

        window?.rootViewController = navigationController


        return true
    }



}

