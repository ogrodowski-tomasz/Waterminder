//
//  UIViewController+Extensions.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

extension UIViewController {

    func dismissBarButton(target: AnyObject?, action: Selector?) -> UIBarButtonItem {
        let button = UIBarButtonItem()
        button.tintColor = .systemRed
        button.title = "Dismiss"
        button.target = target
        button.action = action
        return button
    }

    func saveBarButton(target: AnyObject?, action: Selector?) -> UIBarButtonItem {
        let button = UIBarButtonItem()
        button.tintColor = .systemGreen
        button.title = "✓ Save"
        button.target = target
        button.action = action
        return button
    }

}
