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

    func customSheetView(backgroundColor: UIColor?) -> UIView {
        let sheetView = UIView()
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.backgroundColor = backgroundColor
        sheetView.layer.cornerRadius = 20
        sheetView.layer.masksToBounds = true
        return sheetView
    }

    func customTextField(placeholderText: String, tintColor: UIColor?, delegate: UITextFieldDelegate, initialText: String?, returnKeyType: UIReturnKeyType) -> UITextField {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = tintColor?.cgColor
        txtField.layer.cornerRadius = 5
        txtField.layer.masksToBounds = true
        txtField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor : tintColor?.withAlphaComponent(0.5) as Any])
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        txtField.leftViewMode = .always
        txtField.textColor = tintColor
        txtField.returnKeyType = returnKeyType
        txtField.delegate = delegate
        txtField.text = initialText
        return txtField
    }

}