//
//  UIViewController+Extensions.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

typealias UIImagePickerDelegatable = UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate

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

    func customDatePickerLabel(textColor: UIColor?, fontSize: CGFloat = 15) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Watering date: "
        label.textColor = textColor
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: fontSize)
        return label
    }

    func customAddPhotoView(
        tintColor: UIColor?,
        initialImage: UIImage?,
        renderingMode: UIImage.RenderingMode,
        cornerRadius: CGFloat,
        tapTarget: Any?,
        tapAction: Selector?
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = initialImage?.withRenderingMode(renderingMode)
        imageView.tintColor = tintColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        let addPhotoTap = UITapGestureRecognizer(target: tapTarget, action: tapAction)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(addPhotoTap)
        return imageView
    }

    func customDatePicker(
        tintColor: UIColor?,
        backgroundColor: UIColor?,
        contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .trailing,
        initialDate: Date? = nil
    ) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.backgroundColor = backgroundColor
        picker.tintColor = tintColor
        picker.layer.borderColor = tintColor?.cgColor
        picker.layer.borderWidth = 1
        picker.layer.cornerRadius = 5
        picker.layer.masksToBounds = true
        picker.contentHorizontalAlignment = contentHorizontalAlignment
        if let initialDate {
            picker.date = initialDate
        }
        return picker
    }

    func photoPickerActionSheet(router: AnyRouter, delegate: UIImagePickerDelegatable) -> UIAlertController {
        let actionSheet = UIAlertController(title: "Source", message: "How do you want to add photo!", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            router.navigateTo(route: .imagePicker(sourceType: .camera, delegate: delegate), animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { _ in
            router.navigateTo(route: .imagePicker(sourceType: .library, delegate: delegate), animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        return actionSheet
    }

    func resignTextFields(_ textFields: [UITextField]) {
        textFields.forEach { txtField in
            txtField.resignFirstResponder()
        }
    }

}
