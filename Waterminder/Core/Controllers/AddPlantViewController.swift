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
    private var addPhotoView = UIImageView()
    private var nameTextField = UITextField()
    private var overviewTextField = UITextField()
    private var datePickerLabel: UILabel = UILabel()
    private var datePicker = UIDatePicker()

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

        nameTextField = customTextField(
            placeholderText: "Plant's Name...",
            tintColor: UIColor.theme.night,
            delegate: self,
            initialText: nil,
            returnKeyType: .next)

        overviewTextField = customTextField(
            placeholderText: "Short descripton...",
            tintColor: UIColor.theme.night,
            delegate: self,
            initialText: nil,
            returnKeyType: .done)

        datePickerLabel = customDatePickerLabel(
            textColor: UIColor.theme.night)

        addPhotoView = customAddPhotoView(
            tintColor: UIColor.theme.shamrockGreen,
            initialImage: UIImage(named: "plus_photo"),
            renderingMode: .alwaysTemplate,
            cornerRadius: AddPlantViewController.addPhotoButtonHeight / 2,
            tapTarget: self,
            tapAction: #selector(handleAddPhotoTap))

        datePicker = customDatePicker(
            tintColor: UIColor.theme.night,
            backgroundColor: UIColor.theme.shamrockGreen)

        let bgTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBgTap))
        view.addGestureRecognizer(bgTapGesture)
    }

    private func layout() {
        view.addSubview(addPhotoView)
        view.addSubview(customSheetView)
        customSheetView.addSubview(nameTextField)
        customSheetView.addSubview(overviewTextField)

        let datePickerStack = UIStackView(arrangedSubviews: [datePickerLabel, datePicker])
        datePickerStack.translatesAutoresizingMaskIntoConstraints = false
        datePickerStack.axis = .horizontal
        datePickerStack.spacing = 10
        datePickerStack.alignment = .center
        datePickerStack.distribution = .equalSpacing
        view.addSubview(datePickerStack)

        NSLayoutConstraint.activate([
            addPhotoView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 5),
            addPhotoView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addPhotoView.widthAnchor.constraint(equalToConstant: AddPlantViewController.addPhotoButtonHeight),
            addPhotoView.heightAnchor.constraint(equalToConstant: AddPlantViewController.addPhotoButtonHeight),

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

            datePickerStack.topAnchor.constraint(equalToSystemSpacingBelow: overviewTextField.bottomAnchor, multiplier: 1),
            datePickerStack.leadingAnchor.constraint(equalToSystemSpacingAfter: customSheetView.leadingAnchor, multiplier: 1),
            customSheetView.trailingAnchor.constraint(equalToSystemSpacingAfter: datePickerStack.trailingAnchor, multiplier: 2),
            datePickerStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc
    private func handleBgTap() {
        resignTextFields([nameTextField, overviewTextField])
    }

    @objc
    private func handleDismissTap() {
        router.pop(animated: true)
    }

    @objc
    private func handleSaveTap() {
        var photo = UIImage(named: "plant")!
        guard let newPhoto = addPhotoView.image else { return }
        if !newPhoto.isEqualTo(image: UIImage(named: "plus_photo")) {
            photo = newPhoto
        }
        viewModel.addPlant(
            name: nameTextField.text ?? "N/A",
            overview: overviewTextField.text ?? "N/A",
            wateringDate: datePicker.date,
            photo: photo)
        router.pop(animated: true)
    }

    @objc
    private func handleAddPhotoTap() {
        resignTextFields([nameTextField, overviewTextField])
        let actionSheet = photoPickerActionSheet(router: router, delegate: self)
        router.present(actionSheet)
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
            addPhotoView.image = pickedImage
        } else {
            print("DEBUG: Couldnt parse image")
        }
        dismiss(animated: true)
    }
}


