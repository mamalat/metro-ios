//
//  MTRDirectionChangeStationCell.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2019-06-22.
//  Copyright © 2019 Iaroslav Mamalat. All rights reserved.
//

import UIKit
import Localize_Swift
import Cartography
import DeviceKit
//
//class MTRDirectionChangeStationCell: UICollectionViewCell {
//    private lazy var stationNameLabel: UILabel = {
//        let l = UILabel()
//        l.numberOfLines = 1
//        l.textColor = UIColor(red:0.28, green:0.31, blue:0.36, alpha:1.00)
//        l.font = .systemFont(ofSize: 20, weight: .bold)
//        return l
//    }()
//
//    private lazy var secondaryNameLabel: UILabel = {
//        let l = UILabel()
//        l.numberOfLines = 1
//        l.textColor = UIColor(red:0.28, green:0.31, blue:0.36, alpha: 0.50)
//        l.font = .systemFont(ofSize: 14, weight: .semibold)
//        return l
//    }()
//
//    private lazy var changeStationNameLabel: UILabel = {
//        let l = UILabel()
//        l.numberOfLines = 1
//        l.textColor = UIColor(red:0.28, green:0.31, blue:0.36, alpha:1.00)
//        l.font = .systemFont(ofSize: 20, weight: .bold)
//        return l
//    }()
//
//    private lazy var changeSecondaryNameLabel: UILabel = {
//        let l = UILabel()
//        l.numberOfLines = 1
//        l.textColor = UIColor(red:0.28, green:0.31, blue:0.36, alpha: 0.50)
//        l.font = .systemFont(ofSize: 14, weight: .semibold)
//        return l
//    }()
//
//    private lazy var stationColorView: UIView = {
//        let v = UIView()
//        v.layer.cornerRadius = 8/2
//        return v
//    }()
//
//    private lazy var secondaryStationColorView: UIView = {
//        let v = UIView()
//        v.layer.cornerRadius = 12/2
//        v.layer.borderColor = UIColor(named: "White")?.cgColor
//        v.layer.borderWidth = 2
//        return v
//    }()
//
//    private lazy var changeLineLabel: UILabel = {
//        let l = UILabel()
//        l.numberOfLines = 1
//        l.text = "change-line".localized()
//        l.textAlignment = .right
//        l.textColor = UIColor(red:0.59, green:0.66, blue:0.77, alpha:1.00)
//        l.font = .systemFont(ofSize: 13, weight: .semibold)
//        return l
//    }()
//
//    private lazy var changeStationBoxView: UIView = {
//        let v = UIView()
//        v.backgroundColor = UIColor(red:0.59, green:0.66, blue:0.77, alpha:0.10)
//        v.layer.cornerRadius = 4
//        return v
//    }()
//
//    private lazy var changeStationColorView: UIView = {
//        let v = UIView()
//        v.layer.cornerRadius = 8/2
//        return v
//    }()
//
//    lazy var lineView: UIView = {
//        let v = UIView()
//        v.backgroundColor = UIColor(red:0.59, green:0.66, blue:0.77, alpha:0.10)
//        return v
//    }()
//
//    func set(_ station: MTRStation, toStation: MTRStation) {
//        let currentLanguage = Locale(rawValue: Localize.currentLanguage())!
//        station.locale = currentLanguage
//        stationNameLabel.text = station.value
//
//        toStation.locale = currentLanguage
//        changeStationNameLabel.text = toStation.value
//
//        if currentLanguage == .Ukrainian {
//            station.locale = .English
//            toStation.locale = .English
//        } else {
//            station.locale = .Ukrainian
//            toStation.locale = .Ukrainian
//        }
//
//        secondaryStationColorView.backgroundColor =
//        station.connection != nil ? station.color : station.connection?.color
//        secondaryStationColorView.layer.borderWidth = station.connection != nil ? 2 : 0
//        secondaryNameLabel.text = station.value
//        changeSecondaryNameLabel.text = toStation.value
//        stationColorView.backgroundColor = station.connection != nil ? station.connection?.color : station.color
//
//        changeStationColorView.backgroundColor = toStation.color
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        backgroundColor = UIColor(named: "White")
//        contentView.addSubview(stationNameLabel)
//        contentView.addSubview(secondaryNameLabel)
//        contentView.addSubview(stationColorView)
//        contentView.addSubview(lineView)
//        contentView.addSubview(secondaryStationColorView)
//        contentView.addSubview(changeStationBoxView)
//        contentView.addSubview(changeLineLabel)
//
//        changeStationBoxView.addSubview(changeStationNameLabel)
//        changeStationBoxView.addSubview(changeSecondaryNameLabel)
//        changeStationBoxView.addSubview(changeStationColorView)
//
//        snapshotView(afterScreenUpdates: true)
//        layoutUI()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func prepareForReuse() {
//        stationNameLabel.text = nil
//        secondaryNameLabel.text = nil
//        stationColorView.backgroundColor = nil
//        secondaryStationColorView.backgroundColor = nil
//    }
//
//    private func layoutUI() {
//        let device = Device()
//
//        constrain(stationNameLabel, secondaryNameLabel, stationColorView, secondaryStationColorView) { station, secondary, color, secondaryColor in
//            station.top == station.superview!.top + 12
//            station.leading == station.superview!.leading + 20
//
//            secondary.leading == station.leading
//            secondary.top == station.bottom + 2
//
//
//            // move to top on small phones
//            if device.diagonal <= 4 {
//                color.centerY == station.centerY
//            } else {
//                color.top == station.top + 16
//            }
//
//            color.trailing == color.superview!.trailing - 20
//            color.height == 8
//            color.width == 8
//
//            secondaryColor.width == 12
//            secondaryColor.height == 12
//            secondaryColor.centerY == color.centerY
//            secondaryColor.leading == color.leading - 10
//
//        }
//
//        constrain(secondaryNameLabel, changeLineLabel, changeStationBoxView, lineView, secondaryStationColorView) { fromSecondary, changeLineLabel, changeBox, line, color in
//
//            if device.diagonal <= 4 {
//                changeLineLabel.trailing == changeLineLabel.superview!.trailing - 20
//                changeLineLabel.bottom == fromSecondary.bottom
//            } else {
//                changeLineLabel.trailing == color.leading - 6
//                changeLineLabel.centerY == color.centerY - 1
//            }
//
//            changeBox.top == fromSecondary.bottom + 8
//            changeBox.leading == changeBox.superview!.leading + 12
//            changeBox.trailing == changeBox.superview!.trailing - 12
//            changeBox.height == 60 ~ .defaultHigh
//            changeBox.bottom == changeBox.superview!.bottom - 16
//
//            line.leading == line.superview!.leading + 20
//            line.trailing == line.superview!.trailing - 20
//            line.bottom == line.superview!.bottom
//            line.height == 1
//        }
//
//        constrain(changeStationNameLabel, changeSecondaryNameLabel, changeStationColorView) { station, secondary, color in
//            station.top == station.superview!.top + 8
//            station.leading == station.superview!.leading + 8
//
//            secondary.leading == station.leading
//            secondary.top == station.bottom + 2
//
//            secondary.bottom == secondary.superview!.bottom - 8
//
//            color.centerY == color.superview!.centerY
//            color.trailing == color.superview!.trailing - 8
//            color.height == 8
//            color.width == 8
//        }
//    }
//
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        setNeedsLayout()
//        layoutIfNeeded()
//        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//        var newFrame = layoutAttributes.frame
//        // note: don't change the width
//        newFrame.size.height = ceil(size.height)
//        layoutAttributes.frame = newFrame
//        return layoutAttributes
//    }
//}

class MTRDirectionChangeStationCell: UICollectionViewCell {
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

    private lazy var changeStationNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private lazy var changeSecondaryNameLabel: UILabel = {
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

    private lazy var changeLineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "change-line".localized()
        label.textAlignment = .right
        label.textColor = UIColor(named: "Dark")
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()

    private lazy var changeStationBoxView: UIView = {
        let view = UIView()
//        v.backgroundColor = UIColor(named: "Dark")?.withAlphaComponent(0.10)
        view.layer.cornerRadius = 4
        return view
    }()

    private lazy var changeStationColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8/2
        return view
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Dark")?.withAlphaComponent(0.10)
        return view
    }()

    lazy var changeLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Dark")?.withAlphaComponent(0.10)
        return view
    }()

    func set(_ station: MTRStation, toStation: MTRStation) {
        let currentLanguage = Locale(rawValue: Localize.currentLanguage())!
        station.locale = currentLanguage
        stationNameLabel.text = station.value

        toStation.locale = currentLanguage
        changeStationNameLabel.text = toStation.value

        if currentLanguage == .Ukrainian {
            station.locale = .English
            toStation.locale = .English
        } else {
            station.locale = .Ukrainian
            toStation.locale = .Ukrainian
        }

        secondaryStationColorView.backgroundColor =
            station.connection != nil ? station.color : station.connection?.color
        secondaryStationColorView.layer.borderWidth = station.connection != nil ? 2 : 0
        secondaryNameLabel.text = station.value
        changeSecondaryNameLabel.text = toStation.value
        stationColorView.backgroundColor = station.connection != nil ? station.connection?.color : station.color

        changeStationColorView.backgroundColor = toStation.color
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(named: "White")
        contentView.addSubview(stationNameLabel)
        contentView.addSubview(secondaryNameLabel)
        contentView.addSubview(stationColorView)
        contentView.addSubview(lineView)
        contentView.addSubview(secondaryStationColorView)
        contentView.addSubview(changeStationBoxView)
        contentView.addSubview(changeLineLabel)

        changeStationBoxView.addSubview(changeLineView)

        changeStationBoxView.addSubview(changeStationNameLabel)
        changeStationBoxView.addSubview(changeSecondaryNameLabel)
        changeStationBoxView.addSubview(changeStationColorView)

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
        let device = Device.current

        constrain(stationNameLabel, secondaryNameLabel, stationColorView, secondaryStationColorView) { station, secondary, color, secondaryColor in
            station.top == station.superview!.top + 12
            station.leading == station.superview!.leading + 20

            secondary.leading == station.leading
            secondary.top == station.bottom + 2

            // move to top on small phones
            if device.diagonal <= 4 {
                color.centerY == station.centerY
            } else {
                color.centerY == station.top + 22
            }

            color.trailing == color.superview!.trailing - 20
            color.height == 8
            color.width == 8

            secondaryColor.width == 12
            secondaryColor.height == 12
            secondaryColor.centerY == color.centerY
            secondaryColor.leading == color.leading - 10

        }

        constrain(secondaryNameLabel, changeLineLabel, changeStationBoxView, lineView, secondaryStationColorView) { fromSecondary, changeLineLabel, changeBox, line, color in

            if device.diagonal <= 4 {
                changeLineLabel.trailing == changeLineLabel.superview!.trailing - 20
                changeLineLabel.bottom == fromSecondary.bottom
            } else {
                changeLineLabel.trailing == color.leading - 6
                changeLineLabel.centerY == color.centerY - 1
            }

            changeBox.top == fromSecondary.bottom + 12
            changeBox.leading == changeBox.superview!.leading + 12
            changeBox.trailing == changeBox.superview!.trailing - 12
            changeBox.height == 64 ~ .defaultHigh
            changeBox.bottom == changeBox.superview!.bottom - 4

            line.leading == line.superview!.leading + 20
            line.trailing == line.superview!.trailing - 20
            line.bottom == line.superview!.bottom
            line.height == 1
        }

        constrain(changeStationNameLabel, changeSecondaryNameLabel, changeStationColorView, changeLineView) { station, secondary, color, line in
            line.leading == line.superview!.leading + 8
            line.trailing == line.superview!.trailing - 8
            line.top == line.superview!.top
            line.height == 1

            station.top == station.superview!.top + 12
            station.leading == station.superview!.leading + 8

            secondary.leading == station.leading
            secondary.top == station.bottom + 2

            secondary.bottom == secondary.superview!.bottom - 8

            color.centerY == color.superview!.centerY + 2
            color.trailing == color.superview!.trailing - 8
            color.height == 8
            color.width == 8
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
