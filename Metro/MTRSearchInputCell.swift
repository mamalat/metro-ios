//
//  MTRSearchInputCell.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2019-06-19.
//  Copyright © 2019 Iaroslav Mamalat. All rights reserved.
//

import UIKit
import Cartography
import Localize_Swift

extension UIButton {
    func setBackgroundColor(color: UIColor?, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext(),
            let color = color {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

class MTRTextField: UITextField {
    let inset: CGFloat = 16

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
}

class MTRSearchInputCell: UICollectionViewCell {
    var delegate: MTRSearchInputDelegate?

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "kyiv".localized()
        label.textColor = UIColor(named: "Black")
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        return label
    }()

    private lazy var whereToLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "where-to".localized()
        label.textColor = UIColor(named: "Dark")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private lazy var boxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "White")
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 14
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor(named: "Dark")?.withAlphaComponent(0.15).cgColor
        return view
    }()

    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Dark")?.withAlphaComponent(0.10)
        return view
    }()

    lazy var fromTextInputView: MTRTextField = {
        let textField = MTRTextField()
        textField.placeholder = "from".localized()
        textField.clipsToBounds = false
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.textColor = UIColor(named: "Black")
        textField.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateFromShit))
        singleTap.numberOfTapsRequired = 1
        textField.addGestureRecognizer(singleTap)
        return textField
    }()

    lazy var toTextInputView: MTRTextField = {
        let textField = MTRTextField()
        textField.placeholder = "to".localized()
        textField.clipsToBounds = false
        textField.backgroundColor = UIColor(named: "White")
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.textColor = UIColor(named: "Black")
        textField.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateToShit))
        singleTap.numberOfTapsRequired = 1
        textField.addGestureRecognizer(singleTap)
        return textField
    }()

    @objc func animateFromShit() {
        delegate?.state = .from
        delegate?.animateThis(view: fromTextInputView)
    }

    @objc func animateToShit() {
        delegate?.state = .to
        delegate?.animateThis(view: toTextInputView)
    }

    @objc func getDirections() {
        delegate?.getDirections()
    }

    lazy var getDirectionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("get-directions".localized(), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 4
        button.setBackgroundColor(color: UIColor(named: "Primary"), forState: .normal)
        button.setBackgroundColor(color: UIColor(named: "Dark"), forState: .disabled)
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowRadius = 14
        button.layer.shadowOpacity = 1
        button.layer.shadowColor = UIColor(named: "Primary")?.cgColor
        return button
    }()

    lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.text = "from".localized()
        label.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        label.textColor = UIColor(named: "White")
        label.isUserInteractionEnabled = false
        return label
    }()

    private lazy var fromLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Dark")
        view.layer.cornerRadius = 4
        view.isUserInteractionEnabled = false
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: -12, height: 0)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 2
        view.layer.shadowColor = UIColor(named: "White")?.cgColor
        return view
    }()

    lazy var toLabel: UILabel = {
        let label = UILabel()
        label.text = "to".localized()
        label.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
        label.textColor = UIColor(named: "White")
        label.isUserInteractionEnabled = false
        return label
    }()

    private lazy var toLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Dark")
        view.layer.cornerRadius = 4
        view.isUserInteractionEnabled = false

        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: -12, height: 0)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 2
        view.layer.shadowColor = UIColor(named: "White")?.cgColor
        return view
    }()

    var group = ConstraintGroup()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(cityLabel)
        contentView.addSubview(whereToLabel)
        contentView.addSubview(boxView)
        boxView.addSubview(fromTextInputView)
        boxView.addSubview(lineView)
        boxView.addSubview(toTextInputView)
        contentView.addSubview(getDirectionsButton)

        fromLabelView.addSubview(fromLabel)
        boxView.addSubview(fromLabelView)

        toLabelView.addSubview(toLabel)
        boxView.addSubview(toLabelView)

        layoutUI()

        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(LCLLanguageChangeNotification),
                                                  object: nil)
    }

    @objc private func updateLanguage() {
        cityLabel.text = "kyiv".localized()
        whereToLabel.text = "where-to".localized()
        fromTextInputView.placeholder = "from".localized()
        toTextInputView.placeholder = "to".localized()
        fromLabel.text = "from".localized()
        toLabel.text = "to".localized()
        getDirectionsButton.setTitle("get-directions".localized(), for: .normal)
    }

    private func layoutUI() {
        constrain(cityLabel, whereToLabel, boxView, getDirectionsButton) { city, whereTo, box, directions in
            city.top == city.superview!.top
            whereTo.top == city.bottom - 4

            box.top == whereTo.bottom + 24
            box.height == 113 ~ .defaultHigh
            box.leading == box.superview!.leading + 16
            box.trailing == box.superview!.trailing - 16

            directions.top == box.bottom + 24
            directions.height == 60 ~ .defaultHigh
            directions.bottom == directions.superview!.bottom

            align(leading: box, whereTo, city, directions)
            align(trailing: box, whereTo, city, directions)
        }

        group = constrain(fromTextInputView, lineView, toTextInputView) { from, line, to in
            from.leading == from.superview!.leading
        }

        constrain(fromTextInputView, lineView, toTextInputView) { from, line, to in
            from.top == from.superview!.top
            from.trailing == from.superview!.trailing

            line.top == from.bottom

            line.height == 1
            line.leading == line.superview!.leading + 16
            line.trailing == line.superview!.trailing - 16

            to.top == line.bottom
            to.leading == to.superview!.leading
            to.trailing == to.superview!.trailing
        }

        constrain(fromLabel, fromTextInputView, fromLabelView) { from, fromInput, box in
            from.centerY == fromInput.centerY

            from.trailing == box.superview!.trailing - 22
            box.trailing == from.trailing + 6
            box.leading == from.leading - 6

            box.top == from.top - 4
            box.bottom == from.bottom + 4
        }

        constrain(toLabel, toTextInputView, toLabelView) { to, toInput, box in
            to.centerY == toInput.centerY

            to.trailing == box.superview!.trailing - 22
            box.trailing == to.trailing + 6
            box.leading == to.leading - 6

            box.top == to.top - 4
            box.bottom == to.bottom + 4
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
