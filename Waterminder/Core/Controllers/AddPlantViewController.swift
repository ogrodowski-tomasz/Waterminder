//
//  AddPlantViewController.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

class AddPlantViewController: UIViewController, UITextFieldDelegate {

    private let viewModel: AnyAddPlantViewModel
    private let router: AnyRouter

    private let dismissBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.tintColor = .systemRed
        button.title = "Dismiss"
        return button
    }()

    private let saveBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.tintColor = .systemGreen
        button.title = "✓ Save"
        return button
    }()

    private let customSheetView: UIView = {
        let sheetView = UIView()
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.backgroundColor = UIColor.theme.shamrockGreen
        sheetView.layer.cornerRadius = 20
        sheetView.layer.masksToBounds = true
        return sheetView
    }()

    private let addPhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var plusImage = UIImage(named: "plus_photo")?.withRenderingMode(.alwaysTemplate)
        button.setImage(plusImage, for: .normal)
        button.tintColor = UIColor.theme.shamrockGreen
        return button
    }()

    private let nameTextField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = UIColor.theme.night?.cgColor
        txtField.layer.cornerRadius = 5
        txtField.layer.masksToBounds = true
        txtField.attributedPlaceholder = NSAttributedString(string: "Plant's name", attributes: [.foregroundColor : UIColor.theme.night?.withAlphaComponent(0.5) as Any])
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        txtField.leftViewMode = .always
        txtField.textColor = UIColor.theme.night
        txtField.returnKeyType = .next
        return txtField
    }()

    private let overviewTextField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = UIColor.theme.night?.cgColor
        txtField.layer.cornerRadius = 5
        txtField.layer.masksToBounds = true
        txtField.attributedPlaceholder = NSAttributedString(string: "Plant's overview", attributes: [.foregroundColor : UIColor.theme.night?.withAlphaComponent(0.5) as Any])
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        txtField.leftViewMode = .always
        txtField.textColor = UIColor.theme.night
        txtField.returnKeyType = .done
        return txtField
    }()

    private let datePickerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Watering date: "
        label.textColor = UIColor.theme.night
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

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
        addPhotoButton.addTarget(self, action: #selector(handlePlusButtonTapped), for: .touchUpInside)
        dismissBarButton.target = self
        dismissBarButton.action = #selector(handleDismissTap)
        navigationItem.setLeftBarButton(dismissBarButton, animated: true)
        saveBarButton.target = self
        saveBarButton.action = #selector(handleSaveTap)
        navigationItem.setRightBarButton(saveBarButton, animated: true)
        nameTextField.delegate = self
        overviewTextField.delegate = self

        let bgTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBgTap))
        view.addGestureRecognizer(bgTapGesture)
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
            addPhotoButton.bottomAnchor.constraint(equalToSystemSpacingBelow: view.centerYAnchor, multiplier: -7),

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

    @objc
    private func handlePlusButtonTapped() {
        print("DEBUG: present image picker")
    }

    @objc
    private func handleBgTap() {
        nameTextField.resignFirstResponder()
        overviewTextField.resignFirstResponder()
    }

    @objc
    private func handleDismissTap() {
        router.pop(animated: true)
    }

    @objc
    private func handleSaveTap() {
        guard let defaultImage = UIImage(named: "plant") else { return }
        viewModel.addPlant(
            name: nameTextField.text ?? "N/A",
            overview: overviewTextField.text ?? "N/A",
            wateringDate: datePicker.date,
            photo: defaultImage)
        router.pop(animated: true)
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


