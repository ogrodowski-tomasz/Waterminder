//
//  EditPlantViewController.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

class EditPlantViewController: UIViewController {

    static let imageSide: CGFloat = 250

    private let viewModel: AnyEditPlantViewModel

    private let router: AnyRouter

    private var customSheetView = UIView()
    private var addPhotoView = UIImageView()
    private var nameTextField = UITextField()
    private var overviewTextField = UITextField()
    private var datePickerLabel = UILabel()
    private var datePicker = UIDatePicker()

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
        overrideUserInterfaceStyle = .dark
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
        navigationItem.setLeftBarButton(dismissBarButton(
            target: self,
            action: #selector(handleDismiss)
        ), animated: true)

        navigationItem.setRightBarButton(saveBarButton(
            target: self,
            action: #selector(handleSave)
        ), animated: true)

        customSheetView = customSheetView(
            backgroundColor: UIColor.theme.night)

        nameTextField = customTextField(
            placeholderText: "Plant's Name...",
            tintColor: UIColor.theme.shamrockGreen,
            delegate: self,
            initialText: viewModel.initialName,
            returnKeyType: .next)

        overviewTextField = customTextField(
            placeholderText: "Short description...",
            tintColor: UIColor.theme.shamrockGreen,
            delegate: self,
            initialText: viewModel.initialOverview,
            returnKeyType: .done)

        datePickerLabel = customDatePickerLabel(
            textColor: UIColor.theme.shamrockGreen)

        addPhotoView = customAddPhotoView(
            tintColor: nil,
            initialImage: viewModel.initialPhoto,
            renderingMode: .alwaysOriginal,
            cornerRadius: EditPlantViewController.imageSide / 2,
            tapTarget: self,
            tapAction: #selector(handleAddPhotoTap))

        datePicker = customDatePicker(
            tintColor: UIColor.theme.shamrockGreen,
            backgroundColor: UIColor.theme.night,
            initialDate: viewModel.initialWateringTime)

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

        view.addSubview(addPhotoView)

        NSLayoutConstraint.activate([
            customSheetView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
            customSheetView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: customSheetView.trailingAnchor, multiplier: 0),
            customSheetView.heightAnchor.constraint(equalToConstant: 300),

            customSheetStack.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            customSheetStack.leadingAnchor.constraint(equalToSystemSpacingAfter: customSheetView.leadingAnchor, multiplier: 1),
            customSheetView.trailingAnchor.constraint(equalToSystemSpacingAfter: customSheetStack.trailingAnchor, multiplier: 1),
            customSheetView.bottomAnchor.constraint(equalToSystemSpacingBelow: customSheetStack.bottomAnchor, multiplier: 5),

            addPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotoView.widthAnchor.constraint(equalToConstant: Self.imageSide),
            addPhotoView.topAnchor.constraint(equalToSystemSpacingBelow: customSheetView.bottomAnchor, multiplier: 5),
            addPhotoView.heightAnchor.constraint(equalToConstant: Self.imageSide),
        ])
    }

    @objc
    private func handleBgTap() {
        resignTextFields([nameTextField, overviewTextField])
    }

    @objc
    private func handleDismiss() {
        router.pop(animated: true)
    }

    @objc
    private func handleSave() {
        guard let newName = nameTextField.text else { return }
        guard let newOverview = overviewTextField.text else { return }
        guard let newPhoto = addPhotoView.image else { return }
        viewModel.updatePlant(newName: newName, newOverview: newOverview, newWateringDate: datePicker.date, newPhoto: newPhoto)
        router.pop(animated: true)
    }

    @objc
    private func handleAddPhotoTap() {
        resignTextFields([nameTextField, overviewTextField])
        let actionSheet = photoPickerActionSheet(router: router, delegate: self)
        router.present(actionSheet)
    }

}

extension EditPlantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addPhotoView.image = pickedImage
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
