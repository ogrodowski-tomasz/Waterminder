//
//  EditPlantViewController.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

class EditPlantViewController: UIViewController {

    let viewModel: AnyEditPlantViewModel

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
        sheetView.backgroundColor = UIColor.theme.night
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.layer.cornerRadius = 20
        sheetView.layer.masksToBounds = true
        return sheetView
    }()

    private let addPhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var plusImage = UIImage(named: "plus_photo")?.withRenderingMode(.alwaysTemplate)
        button.setImage(plusImage, for: .normal)
        button.tintColor = UIColor.theme.night
        return button
    }()

    private let nameTextField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = UIColor.theme.shamrockGreen?.cgColor
        txtField.layer.cornerRadius = 5
        txtField.layer.masksToBounds = true
        txtField.attributedPlaceholder = NSAttributedString(string: "Plant's name", attributes: [.foregroundColor : UIColor.theme.shamrockGreen?.withAlphaComponent(0.5) as Any])
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        txtField.leftViewMode = .always
        txtField.textColor = UIColor.theme.shamrockGreen
        txtField.returnKeyType = .next
        return txtField
    }()

    private let overviewTextField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.layer.borderWidth = 1
        txtField.layer.borderColor = UIColor.theme.shamrockGreen?.cgColor
        txtField.layer.cornerRadius = 5
        txtField.layer.masksToBounds = true
        txtField.attributedPlaceholder = NSAttributedString(string: "Plant's overview", attributes: [.foregroundColor : UIColor.theme.shamrockGreen?.withAlphaComponent(0.5) as Any])
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        txtField.leftViewMode = .always
        txtField.textColor = UIColor.theme.shamrockGreen
        txtField.returnKeyType = .done
        return txtField
    }()

    private let datePickerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Watering date: "
        label.textColor = UIColor.theme.shamrockGreen
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.backgroundColor = UIColor.theme.shamrockGreen
        picker.layer.borderColor = UIColor.theme.shamrockGreen?.cgColor
        picker.layer.borderWidth = 1
        picker.layer.cornerRadius = 5
        picker.layer.masksToBounds = true
        picker.contentHorizontalAlignment = .center
        return picker
    }()

    init(viewModel: AnyEditPlantViewModel, router: AnyRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.theme.shamrockGreen
        setup()
        layout()


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .darkContent
    }

    private func setup() {
        dismissBarButton.target = self
        dismissBarButton.action = #selector(handleDismiss)
        navigationItem.setLeftBarButton(dismissBarButton, animated: true)

        saveBarButton.target = self
        saveBarButton.action = #selector(handleSave)
        navigationItem.setRightBarButton(saveBarButton, animated: true)

        nameTextField.text = viewModel.initialName
        overviewTextField.text = viewModel.initialOverview
        datePicker.date = viewModel.initialWateringTime
        addPhotoButton.setImage(viewModel.initialPhoto, for: .normal)
    }

    private func layout() {
        view.addSubview(customSheetView)
        let datePickerStack = UIStackView(arrangedSubviews: [datePickerLabel, datePicker])
        datePickerStack.translatesAutoresizingMaskIntoConstraints = false
        datePickerStack.axis = .horizontal
        datePickerStack.spacing = 10
        datePickerStack.alignment = .center
        datePickerStack.distribution = .equalSpacing

        let customSheetStack = UIStackView(arrangedSubviews: [nameTextField, overviewTextField, datePickerStack])
        customSheetStack.translatesAutoresizingMaskIntoConstraints = false
        customSheetStack.axis = .vertical
        customSheetStack.spacing = 10
        customSheetStack.distribution = .fillEqually
        customSheetView.addSubview(customSheetStack)

        view.addSubview(addPhotoButton)

        NSLayoutConstraint.activate([
            customSheetView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
            customSheetView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: customSheetView.trailingAnchor, multiplier: 0),
            customSheetView.heightAnchor.constraint(equalToConstant: 300),

            customSheetStack.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            customSheetStack.leadingAnchor.constraint(equalToSystemSpacingAfter: customSheetView.leadingAnchor, multiplier: 1),
            customSheetView.trailingAnchor.constraint(equalToSystemSpacingAfter: customSheetStack.trailingAnchor, multiplier: 1),
            customSheetView.bottomAnchor.constraint(equalToSystemSpacingBelow: customSheetStack.bottomAnchor, multiplier: 5),

            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 250),
            addPhotoButton.topAnchor.constraint(equalToSystemSpacingBelow: customSheetView.bottomAnchor, multiplier: 5),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 250),
        ])
    }

    @objc
    private func handleDismiss() {
        router.pop(animated: true)
    }

    @objc
    private func handleSave() {
        guard let newName = nameTextField.text else { return }
        guard let newOverview = overviewTextField.text else { return }
        viewModel.updatePlant(newName: newName, newOverview: newOverview, newWateringDate: datePicker.date, newPhoto: viewModel.initialPhoto)
        router.pop(animated: true)
    }

}
