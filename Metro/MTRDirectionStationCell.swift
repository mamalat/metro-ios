//
//  MTRDirectionStationCell.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2019-06-22.
//  Copyright © 2019 Iaroslav Mamalat. All rights reserved.
//

import UIKit
import Localize_Swift
import Cartography

class MTRDirectionStationCell: UICollectionViewCell {
    private lazy var stationNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private lazy var secondaryNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(named: "Black")?.withAlphaComponent(0.50)
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()

    private lazy var stationColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8/2
        return view
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Dark")?.withAlphaComponent(0.10)
        return view
    }()

    func set(_ station: MTRStation) {
        let currentLanguage = Locale(rawValue: Localize.currentLanguage())!
        station.locale = currentLanguage
        stationNameLabel.text = station.value

        if currentLanguage == .Ukrainian {
            station.locale = .English
        } else {
            station.locale = .Ukrainian
        }

        secondaryNameLabel.text = station.value
        stationColorView.backgroundColor = station.color
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(named: "White")
        contentView.addSubview(stationNameLabel)
        contentView.addSubview(secondaryNameLabel)
        contentView.addSubview(stationColorView)
        contentView.addSubview(lineView)

        snapshotView(afterScreenUpdates: true)
        layoutUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        stationNameLabel.text = nil
        secondaryNameLabel.text = nil
        stationColorView.backgroundColor = nil
    }

    private func layoutUI() {
        constrain(stationNameLabel, secondaryNameLabel, stationColorView, lineView) { station, secondary, color, line in
            station.top == station.superview!.top + 12
            station.leading == station.superview!.leading + 20

            secondary.leading == station.leading
            secondary.top == station.bottom + 2
            secondary.bottom == secondary.superview!.bottom - 12

            color.centerY == color.superview!.centerY
            color.trailing == color.superview!.trailing - 20
            color.height == 8
            color.width == 8

            line.leading == line.superview!.leading + 20
            line.trailing == line.superview!.trailing - 20
            line.bottom == line.superview!.bottom
            line.height == 1
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}
