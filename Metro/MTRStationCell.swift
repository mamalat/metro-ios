//
//  MTRStationCell.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2019-06-20.
//  Copyright © 2019 Iaroslav Mamalat. All rights reserved.
//

import UIKit
import Cartography
import Localize_Swift

extension MTRStation {
    var color: UIColor? {
        get {
            switch self.lineId {
            case "red": return UIColor(named: "Secondary")
            case "blue": return UIColor(named: "Primary")
            default: return UIColor(named: "Tertiary")
            }
        }
    }
}

class MTRStationCell: UICollectionViewCell {
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

    private lazy var secondaryStationColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12/2
        view.layer.borderColor = UIColor(named: "White")?.cgColor
        view.layer.borderWidth = 2
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

        secondaryStationColorView.backgroundColor =
            station.connection != nil ? station.color : station.connection?.color
        secondaryStationColorView.layer.borderWidth = station.connection != nil ? 2 : 0
        secondaryNameLabel.text = station.value
        stationColorView.backgroundColor = station.connection != nil ? station.connection?.color : station.color
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(named: "White")
        contentView.addSubview(stationNameLabel)
        contentView.addSubview(secondaryNameLabel)
        contentView.addSubview(stationColorView)
        contentView.addSubview(lineView)
        contentView.addSubview(secondaryStationColorView)

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
        secondaryStationColorView.backgroundColor = nil
    }

    private func layoutUI() {
        constrain(stationNameLabel, secondaryNameLabel, stationColorView, lineView, secondaryStationColorView) { station, secondary, color, line, secondaryColor in
            station.top == station.superview!.top + 12
            station.leading == station.superview!.leading + 16

            secondary.leading == station.leading
            secondary.top == station.bottom + 2
            secondary.bottom == secondary.superview!.bottom - 12

            color.centerY == color.superview!.centerY
            color.trailing == color.superview!.trailing - 16
            color.height == 8
            color.width == 8

            secondaryColor.width == 12
            secondaryColor.height == 12
            secondaryColor.centerY == color.centerY
            secondaryColor.leading == color.leading - 10

            line.leading == line.superview!.leading + 16
            line.trailing == line.superview!.trailing - 16
            line.bottom == line.superview!.bottom
            line.height == 1
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
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
