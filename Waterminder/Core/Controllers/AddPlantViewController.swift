//
//  AddPlantViewController.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

class AddPlantViewController: UIViewController, UITextFieldDelegate {

    static let addPhotoButtonHeight: CGFloat = 200

    private let viewModel: AnyAddPlantViewModel
    private let router: AnyRouter

    private var customSheetView = UIView()

    private let addPhotoButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "plus_photo")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.theme.shamrockGreen
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = AddPlantViewController.addPhotoButtonHeight / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private var nameTextField = UITextField()
    private var overviewTextField = UITextField()
    private var datePickerLabel: UILabel = UILabel()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.tintColor = UIColor.theme.night
        picker.layer.borderColor = UIColor.theme.night?.cgColor
        picker.layer.borderWidth = 1
        picker.layer.cornerRadius = 5
        picker.layer.masksToBounds = true
        return picker
    }()

    init(viewModel: AnyAddPlantViewModel, router: AnyRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.theme.night
        setup()
        layout()
    }

    private func setup() {
        navigationItem.setLeftBarButton(dismissBarButton(target: self, action: #selector(handleDismissTap)), animated: true)
        navigationItem.setRightBarButton(saveBarButton(target: self, action: #selector(handleSaveTap)), animated: true)

        customSheetView = customSheetView(backgroundColor: UIColor.theme.shamrockGreen)

        nameTextField = customTextField(placeholderText: "Plant's Name...", tintColor: UIColor.theme.night, delegate: self, initialText: nil, returnKeyType: .next)
        overviewTextField = customTextField(placeholderText: "Short descripton...", tintColor: UIColor.theme.night, delegate: self, initialText: nil, returnKeyType: .done)
        datePickerLabel = customDatePickerLabel(textColor: UIColor.theme.night)

        let bgTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBgTap))
        view.addGestureRecognizer(bgTapGesture)

        let presentImagePickerGesture = UITapGestureRecognizer(target: self, action: #selector(handleAddPhotoTap))
        addPhotoButton.isUserInteractionEnabled = true
        addPhotoButton.addGestureRecognizer(presentImagePickerGesture)
    }

    private func layout() {
        view.addSubview(addPhotoButton)
        view.addSubview(customSheetView)
        customSheetView.addSubview(nameTextField)
        customSheetView.addSubview(overviewTextField)
        customSheetView.addSubview(datePickerLabel)
        customSheetView.addSubview(datePicker)

        NSLayoutConstraint.activate([
            addPhotoButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 5),
            addPhotoButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: AddPlantViewController.addPhotoButtonHeight),
            addPhotoButton.heightAnchor.constraint(equalToConstant: AddPlantViewController.addPhotoButtonHeight),

            customSheetView.topAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: 0),
            customSheetView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: customSheetView.trailingAnchor, multiplier: 0),
            customSheetView.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 0),

            nameTextField.topAnchor.constraint(equalToSystemSpacingBelow: customSheetView.topAnchor, multiplier: 3),
            nameTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: customSheetView.leadingAnchor, multiplier: 2),
            customSheetView.trailingAnchor.constraint(equalToSystemSpacingAfter: nameTextField.trailingAnchor, multiplier: 2),
            nameTextField.heightAnchor.constraint(equalToConstant: 60),

            overviewTextField.topAnchor.constraint(equalToSystemSpacingBelow: nameTextField.bottomAnchor, multiplier: 1),
            overviewTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: customSheetView.leadingAnchor, multiplier: 2),
            customSheetView.trailingAnchor.constraint(equalToSystemSpacingAfter: overviewTextField.trailingAnchor, multiplier: 2),
            overviewTextField.heightAnchor.constraint(equalToConstant: 60),

            datePickerLabel.topAnchor.constraint(equalToSystemSpacingBelow: overviewTextField.bottomAnchor, multiplier: 1),
            datePickerLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: customSheetView.leadingAnchor, multiplier: 2),
            datePickerLabel.heightAnchor.constraint(equalToConstant: 50),
            datePickerLabel.widthAnchor.constraint(equalToConstant: 150),

            datePicker.widthAnchor.constraint(equalToConstant: 100),
            customSheetView.trailingAnchor.constraint(equalToSystemSpacingAfter: datePicker.trailingAnchor, multiplier: 2),
            datePicker.centerYAnchor.constraint(equalTo: datePickerLabel.centerYAnchor),

        ])
    }

    private func resignTextFields() {
        nameTextField.resignFirstResponder()
        overviewTextField.resignFirstResponder()
    }

    @objc
    private func handleBgTap() {
        resignTextFields()
    }

    @objc
    private func handleDismissTap() {
        router.pop(animated: true)
    }

    @objc
    private func handleSaveTap() {
        guard let defaultImage = addPhotoButton.image else { return }
        viewModel.addPlant(
            name: nameTextField.text ?? "N/A",
            overview: overviewTextField.text ?? "N/A",
            wateringDate: datePicker.date,
            photo: defaultImage)
        router.pop(animated: true)
    }

    @objc
    private func handleAddPhotoTap() {
        resignTextFields()
        let actionSheet = UIAlertController(title: "Source", message: "How do you want to add photo!", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.router.navigateTo(route: .imagePicker(sourceType: .camera, delegate: self), animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.router.navigateTo(route: .imagePicker(sourceType: .library, delegate: self), animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        navigationController?.present(actionSheet, animated: true)
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            overviewTextField.becomeFirstResponder()
        } else {
            overviewTextField.resignFirstResponder()
        }
        return true
    }
}

extension AddPlantViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addPhotoButton.image = pickedImage
        } else {
            print("DEBUG: Couldnt parse image")
        }
        dismiss(animated: true)
    }
}


