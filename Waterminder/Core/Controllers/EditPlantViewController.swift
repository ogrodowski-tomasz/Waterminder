//
//  EditPlantViewController.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

class EditPlantViewController: UIViewController {

    static let imageSide: CGFloat = 250

    let viewModel: AnyEditPlantViewModel

    private let router: AnyRouter

    private let customSheetView: UIView = {
        let sheetView = UIView()
        sheetView.backgroundColor = UIColor.theme.night
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.layer.cornerRadius = 20
        sheetView.layer.masksToBounds = true
        return sheetView
    }()

    private let addPhotoButton: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "plus_photo")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.theme.night
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = EditPlantViewController.imageSide / 2
        imageView.layer.masksToBounds = true
        return imageView
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
        navigationItem.setLeftBarButton(dismissBarButton(target: self, action: #selector(handleDismiss)), animated: true)
        navigationItem.setRightBarButton(saveBarButton(target: self, action: #selector(handleSave)), animated: true)

        nameTextField.text = viewModel.initialName
        nameTextField.delegate = self
        overviewTextField.text = viewModel.initialOverview
        overviewTextField.delegate = self

        datePicker.date = viewModel.initialWateringTime

        addPhotoButton.image = viewModel.initialPhoto
        let addPhotoTap = UITapGestureRecognizer(target: self, action: #selector(handleAddPhotoTap))
        addPhotoButton.addGestureRecognizer(addPhotoTap)
        addPhotoButton.isUserInteractionEnabled = true

        let bgTap = UITapGestureRecognizer(target: self, action: #selector(handleBgTap))
        view.addGestureRecognizer(bgTap)


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
            addPhotoButton.widthAnchor.constraint(equalToConstant: Self.imageSide),
            addPhotoButton.topAnchor.constraint(equalToSystemSpacingBelow: customSheetView.bottomAnchor, multiplier: 5),
            addPhotoButton.heightAnchor.constraint(equalToConstant: Self.imageSide),
        ])
    }

    @objc
    private func handleBgTap() {
        nameTextField.resignFirstResponder()
        overviewTextField.resignFirstResponder()
    }

    @objc
    private func handleDismiss() {
        router.pop(animated: true)
    }

    @objc
    private func handleSave() {
        guard let newName = nameTextField.text else { return }
        guard let newOverview = overviewTextField.text else { return }
        guard let newPhoto = addPhotoButton.image else { return }
        viewModel.updatePlant(newName: newName, newOverview: newOverview, newWateringDate: datePicker.date, newPhoto: newPhoto)
        router.pop(animated: true)
    }

    @objc
    private func handleAddPhotoTap() {
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

}

extension EditPlantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addPhotoButton.image = pickedImage
        } else {
            print("DEBUG: Couldnt parse image")
        }
        dismiss(animated: true)
    }
}

extension EditPlantViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            overviewTextField.becomeFirstResponder()
        } else {
            overviewTextField.resignFirstResponder()
        }
        return true
    }

}
