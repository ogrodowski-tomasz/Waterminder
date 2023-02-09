//
//  PlantTableViewCell.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    static let identifier = "PlantTableViewCell"

    static let imageHeight = 80.0

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.theme.night
        imageView.layer.cornerRadius = PlantTableViewCell.imageHeight / 2
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.night
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.night?.withAlphaComponent(0.5)
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()

    private let wateringDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.theme.night?.withAlphaComponent(0.8)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        backgroundColor = UIColor.theme.shamrockGreen
    }

    private func layout() {
        addSubview(photoImageView)
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, wateringDateLabel, overviewLabel])
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical
        labelStack.spacing = 5
        labelStack.distribution = .fillProportionally

        addSubview(labelStack)

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(
                equalToSystemSpacingBelow: topAnchor, multiplier: 1
            ),
            photoImageView.leadingAnchor.constraint(
                equalToSystemSpacingAfter: leadingAnchor, multiplier: 1
            ),
            photoImageView.heightAnchor.constraint(
                equalToConstant: PlantTableViewCell.imageHeight
            ),
            photoImageView.widthAnchor.constraint(
                equalToConstant: PlantTableViewCell.imageHeight
            ),
            bottomAnchor.constraint(
                equalToSystemSpacingBelow: photoImageView.bottomAnchor, multiplier: 1
            ),
            labelStack.leadingAnchor.constraint(
                equalToSystemSpacingAfter: photoImageView.trailingAnchor, multiplier: 1
            ),
            labelStack.centerYAnchor.constraint(
                equalTo: photoImageView.centerYAnchor
            ),
            trailingAnchor.constraint(
                equalToSystemSpacingAfter: labelStack.trailingAnchor, multiplier: 1
            )
        ])
    }

    func configure(name: String, overview: String, photo: UIImage, wateringDateString: String) {
        nameLabel.text = name
        overviewLabel.text = overview
        photoImageView.image = photo
        wateringDateLabel.text = "Watering time: \(wateringDateString)"
    }

}
