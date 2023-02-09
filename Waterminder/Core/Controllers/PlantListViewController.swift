//
//  PlantListViewController.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 06/02/2023.
//

import UIKit

class PlantListViewController: UIViewController {

    static let addPlantButtonHeight: CGFloat = 40

    var plantListViewModel: AnyPlantListViewModel
    var router: AnyRouter

    private let addPlantButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add New Plant", for: .normal)
        button.setTitleColor(UIColor.theme.shamrockGreen, for: .normal)
        button.backgroundColor = UIColor.theme.night
        button.layer.cornerRadius = PlantListViewController.addPlantButtonHeight / 2
        button.layer.masksToBounds = true
        return button
    }()

    private let plantsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.theme.shamrockGreen
        tableView.register(PlantTableViewCell.self, forCellReuseIdentifier: PlantTableViewCell.identifier)
        return tableView
    }()

    init(
        plantListViewModel: AnyPlantListViewModel,
        router: AnyRouter
    ) {
        self.plantListViewModel = plantListViewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.plantListViewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.theme.shamrockGreen
        setupNavigationBar()
        setupTableView()
        setupButtonTargets()
        layout()
    }

    private func setupNavigationBar() {
        let titleLbl = UILabel()
        titleLbl.text = "Waterminder"
        titleLbl.textColor = UIColor.theme.night
        titleLbl.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        let imageView = UIImageView(image: UIImage(named: "plant"))
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.contentMode = .scaleAspectFit
        let titleView = UIStackView(arrangedSubviews: [imageView, titleLbl])
        titleView.axis = .horizontal
        titleView.spacing = 10.0
        navigationItem.titleView = titleView
    }

    private func setupTableView() {
        plantsTableView.delegate = self
        plantsTableView.dataSource = self
    }

    private func setupButtonTargets() {
        addPlantButton.addTarget(self, action: #selector(handleAddNewProjectTap), for: .touchUpInside)
    }

    private func layout() {
        view.addSubview(addPlantButton)
        view.addSubview(plantsTableView)

        NSLayoutConstraint.activate([
            addPlantButton.topAnchor.constraint(
                equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 3
            ),
            addPlantButton.leadingAnchor.constraint(
                equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1
            ),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(
                equalToSystemSpacingAfter: addPlantButton.trailingAnchor, multiplier: 1
            ),
            addPlantButton.heightAnchor.constraint(
                equalToConstant: PlantListViewController.addPlantButtonHeight + 10
            ),
            plantsTableView.topAnchor.constraint(
                equalToSystemSpacingBelow: addPlantButton.bottomAnchor, multiplier: 0
            ),
            plantsTableView.leadingAnchor.constraint(
                equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0
            ),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(
                equalToSystemSpacingAfter: plantsTableView.trailingAnchor, multiplier: 0
            ),
            plantsTableView.bottomAnchor.constraint(
                equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0
            )
        ])
    }

    @objc
    private func handleAddNewProjectTap() {
        let addPlantVM = AddPlantViewModel(
            plantService: plantListViewModel.plantService,
            notificationsService: plantListViewModel.notificationsService
        )
        router.navigateTo(route: .addNewPlant(viewModel: addPlantVM), animated: true)
    }

}

extension PlantListViewController: AnyPlantViewModelDelegate {
    func didReceivePlants() {
        plantsTableView.reloadData()
    }

    func didReceiveError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.plantListViewModel.getPlants()
        }))

        router.present(alert)
    }

}

extension PlantListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantListViewModel.plants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
            withIdentifier: PlantTableViewCell.identifier,
            for: indexPath) as? PlantTableViewCell
        else {
            return UITableViewCell()
        }
        let plant = plantListViewModel.plants[indexPath.row]
        cell.configure(
            name: plant.name,
            overview: plant.overview,
            photo: plant.photo,
            wateringDateString: plant.wateringDate)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        router.navigateTo(
            route: .editPlant(
                viewModel: EditPlantViewModel(
                    plantService: plantListViewModel.plantService,
                    notificationsService: plantListViewModel.notificationsService,
                    plant: plantListViewModel.plants[indexPath.row]
                )
            ),
            animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] _, _, handler in
            self?.plantListViewModel.removePlant(at: indexPath.row)
            handler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
