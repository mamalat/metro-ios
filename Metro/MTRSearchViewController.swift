//
//  MTRSearchViewController.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2019-06-19.
//  Copyright © 2019 Iaroslav Mamalat. All rights reserved.
//

import UIKit
import IGListKit
import RealmSwift
import Cartography
import Localize_Swift
import DeviceKit

extension MTRSearchViewController: MTRSearchInputDelegate {
    func animateThis(view: UITextField) {
        let archive = NSKeyedArchiver.archivedData(withRootObject: view)
        currentSearchBarPosition = view.superview?.convert(view.frame, to: nil)
        currentSearchBar = NSKeyedUnarchiver.unarchiveObject(with: archive) as? MTRTextField
    }
}

extension UILabel {
    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            } else {
                attributedString = NSMutableAttributedString(string: text ?? "")
                text = nil
            }
            attributedString.addAttribute(NSAttributedString.Key.kern,
                                          value: newValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }

        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern,
                                                                  at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            } else {
                return 0
            }
        }
    }
}

protocol MTRSearchInputDelegate {
    func animateThis(view: UITextField)
    func getDirections()
    var state: MTRSearchState { get set }
}

extension MTRSearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let isNewLine = string == "\n"

        if isNewLine, let textField = textField as? MTRTextField {
            animateOutSearch(textField)
        }

        return !isNewLine
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        resultsViewController.textquery = text
    }
}

class MTRSearchStationSection: NSObject, ListDiffable {
    let stations: [MTRStation]

    init(_ stations: [MTRStation]) { self.stations = stations }

    func diffIdentifier() -> NSObjectProtocol { return self as NSObjectProtocol }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool { return isEqual(object) }
}

final class MTRSearchStationSectionCtrl: ListSectionController {

    var item: MTRSearchStationSection?

    override func numberOfItems() -> Int {
        guard let count = item?.stations.count else { return 1 }
        return count
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 67)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: MTRStationCell.self,
                                                          for: self,
                                                          at: index) as! MTRStationCell
        if let station = item?.stations[index] { cell.set(station) }
        cell.lineView.alpha = item!.stations.count - 1 == index ? 0 : 1
        return cell
    }

    override func didUpdate(to object: Any) { self.item = object as? MTRSearchStationSection }

    override func didSelectItem(at index: Int) {

        guard let resultsViewCtrl = viewController as? MTRSearchResultsViewController,
            let station = item?.stations[index]
            else { return }

        resultsViewCtrl.searchViewController?.setStation(station)
    }
}

class MTRSearchResultsViewController: UIViewController, ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [MTRSearchStationSection(stations)]
    }

    weak var searchViewController: MTRSearchViewController?

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return MTRSearchStationSectionCtrl()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let label = UILabel()
        label.text = "no-station-with-this-name".localized()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(named: "Black")
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 67)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    var textquery = "" {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }

    fileprivate var stations: [MTRStation] {
        let realm = try! Realm()
        let trimmed = textquery.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
    
        var filterQuery =  "name != ''"

        if trimmed != "" {
            filterQuery = "ANY translations.value CONTAINS[cb] '\(trimmed)'"
        }

//        if let searchViewController = searchViewController {
//            if let from = searchViewController.fromStation, searchViewController.state != .from  {
//                filterQuery += " AND id != '\(from.id)'"
//            }
//
//            if let to = searchViewController.toStation, searchViewController.state != .to {
//                filterQuery += " AND id != '\(to.id)'"
//            }
//        }

        let results = realm.objects(MTRStation.self)
            .filter(filterQuery).sorted(byKeyPath: "name")
        var sorted: [MTRStation] = []
        results.forEach { sorted.append($0) }

        sorted.sort {
            $0.translations.filter("locale.localeString = %@", Localize.currentLanguage()).first!.value < $1.translations.filter("locale.localeString = %@", Localize.currentLanguage()).first!.value
        }

        return sorted

//        if let from = fromStation {
//            filterQuery += " AND id != '\(from.id)'"
//        }

//        let results = realm.objects(MTRStation.self)
//        .filter(filterQuery)
//
//        if textquery == "" {
//            return results.sorted(byKeyPath: "name")
//        }
//
//        return results
    }

    private lazy var shadowView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 14
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor(named: "Dark")?.cgColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "Background")
        view.addSubview(shadowView)
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(named: "White")
        collectionView.layer.cornerRadius = 4

        adapter.dataSource = self
        adapter.collectionView = collectionView

        layoutUI()
    }

    private func layoutUI() {
        constrain(collectionView, shadowView) {
            $0.edges == inset($0.superview!.edges, 16)
            $1.edges == $0.edges
        }
    }
}

enum MTRSearchState {
    case from
    case to
}

class MTRSearchViewController: UIViewController {
    @objc private func openChangeLanguageMenu() {
        let menu = UIAlertController(title: "switch-language".localized(), message: nil, preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil)

        let ukrainianLanguage = UIAlertAction(title: "Українська", style: .default, handler: { _ in
            Localize.setCurrentLanguage("uk")
            self.adapter.performUpdates(animated: true)
        })

        let russianLanguage = UIAlertAction(title: "Русский", style: .default, handler: { _ in
            Localize.setCurrentLanguage("ru")
            self.adapter.performUpdates(animated: true)
        })

        let englishLanguage = UIAlertAction(title: "English", style: .default, handler: { _ in
            Localize.setCurrentLanguage("en")
            self.adapter.performUpdates(animated: true)
        })

        menu.view.tintColor = UIColor(named: "Black")
        menu.addAction(ukrainianLanguage)
        menu.addAction(russianLanguage)
        menu.addAction(englishLanguage)
        menu.addAction(cancelAction)
        present(menu, animated: true)
    }

    @objc private func openWebsite() {
        guard let url = URL(string: "https://kyivmetro.com") else { return }
        UIApplication.shared.open(url)
    }

    private lazy var changeLanguageButton: UIButton = {
        let button = UIButton()
        button.setTitle("language".localized(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(openChangeLanguageMenu), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "Black"), for: .normal)
        return button
    }()

    private lazy var languageImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Language")
        view.contentMode = .center
        let singleTap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(openChangeLanguageMenu))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        return view
    }()

    private lazy var linkBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "White")
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 14
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor(named: "Dark")?.withAlphaComponent(0.15).cgColor
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openWebsite))
        singleTap.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTap)
        return view
    }()

    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.text = "kyivmetro.com"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(named: "Black")
        return label
    }()

    var state: MTRSearchState = .from

    var fromStation: MTRStation?
    var toStation: MTRStation?

    func setStation(_ station: MTRStation) {
        switch state {
        case .from:
            self.fromStation = station
            self.fromStation?.locale = Locale(rawValue: Localize.currentLanguage())!
            currentSearchBar?.text = station.value
        default:
            self.toStation = station
            self.toStation?.locale = Locale(rawValue: Localize.currentLanguage())!
            currentSearchBar?.text = station.value
        }

        animateOutSearch(currentSearchBar)
        adapter.performUpdates(animated: true)
    }

    func getDirections() {
        guard let from = fromStation, let to = toStation else { return }

        let realm = try! Realm()

        var direction: MTRDirection?

        direction = realm.object(ofType: MTRDirection.self, forPrimaryKey: "\(from.id)_\(to.id)")

        try! realm.write {
            if direction == nil {
                realm.add(MTRDirection(from, destination: to))
            } else {
                direction?.lastUsed = Date()
            }
        }

        let directions = MTRDirectionFinder(from: from, to: to)
        let directionsViewController = MTRDirectionsViewController(stations: directions.getPath())
        let backItem = UIBarButtonItem()
        backItem.title = "back".localized()
        navigationController?.navigationBar.topItem?.backBarButtonItem  = backItem
        navigationController?.pushViewController(directionsViewController, animated: true)
    }

    func animateOutSearch(_ oldOne: MTRTextField?) {
        guard let z = oldOne, z.superview != nil, let b = currentSearchBarPosition else { return }

        z.resignFirstResponder()
        z.layoutIfNeeded()

        let device = Device.current

        constrain(z, resultsViewController.view, replace: startConstraintGroup) { current, results in
            if device.diagonal <= 4 {
                current.top == current.superview!.topMargin + b.origin.y + 16
            } else {
                current.top == current.superview!.topMargin + b.origin.y
            }

            current.leading == current.superview!.leading + 16
            current.trailing == current.superview!.trailing - 16
            current.height == 56

            results.top == current.bottom
            results.leading == results.superview!.leading
            results.trailing == results.superview!.trailing
            results.bottom == results.superview!.bottom ~ .defaultHigh
        }

        UIView.animate(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.resultsViewController.view.alpha = 0
            z.alpha = 0
            z.layer.cornerRadius = 0
            z.layer.shadowOffset = CGSize(width: 0, height: 0)
            z.layer.shadowRadius = 0
            z.layer.shadowOpacity = 0
            z.layer.shadowColor = UIColor.clear.cgColor
            self.view.layoutIfNeeded()
        }, completion: { [weak self] _ in

            z.removeFromSuperview()
            self?.resultsViewController.textquery = ""
            self?.resultsViewController.view.removeFromSuperview()
        })
    }

    var startConstraintGroup = ConstraintGroup()

    func animateInSearchBar() {
        guard let currentSearchBar = currentSearchBar,
            let currentSearchBarPosition = currentSearchBarPosition
            else { return }

        currentSearchBar.backgroundColor = UIColor(named: "White")
        currentSearchBar.alpha = 0
        currentSearchBar.text = ""

        let device = Device.current

        resultsViewController.view.alpha = 0
        resultsViewController.textquery = ""

        view.addSubview(resultsViewController.view)
        view.addSubview(currentSearchBar)
        startConstraintGroup = constrain(currentSearchBar, resultsViewController.view) { current, results in
            current.top == current.superview!.top + currentSearchBarPosition.origin.y
            current.leading == current.superview!.leading + 16
            current.trailing == current.superview!.trailing - 16
            current.height == 56
            results.top == current.bottom
            results.leading == results.superview!.leading
            results.trailing == results.superview!.trailing
            results.bottom == results.superview!.bottom ~ .defaultLow
        }

        self.view.layoutIfNeeded()

        constrain(currentSearchBar, resultsViewController.view, replace: startConstraintGroup) { current, results in

            if device.diagonal <= 4 {
                current.top == current.superview!.topMargin + 16
            } else {
                current.top == current.superview!.topMargin
            }

            current.leading == current.superview!.leading + 16
            current.trailing == current.superview!.trailing - 16
            current.height == 56

            results.top == current.bottom
            results.leading == results.superview!.leading
            results.trailing == results.superview!.trailing
            results.bottom == results.superview!.bottom ~ .defaultLow
        }

        currentSearchBar.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.resultsViewController.view.alpha = 1
            self.currentSearchBar?.alpha = 1
            self.currentSearchBar?.layer.cornerRadius = 4
            self.currentSearchBar?.layer.masksToBounds = false
            self.currentSearchBar?.layer.shadowOffset = CGSize(width: 0, height: 6)
            self.currentSearchBar?.layer.shadowRadius = 14
            self.currentSearchBar?.layer.shadowOpacity = 1
            self.currentSearchBar?.layer.shadowColor = UIColor(named: "Dark")?.withAlphaComponent(0.15).cgColor
            self.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.currentSearchBar?.addTarget(self, action: #selector(self?.textFieldDidChange(_:)),
                                              for: .editingChanged)
            self?.currentSearchBar?.delegate = self
        })
    }

    var currentSearchBarPosition: CGRect?
    let currentSearchBarConstraintGroup = ConstraintGroup()
    let resultsViewController = MTRSearchResultsViewController()

    var currentSearchBar: MTRTextField? {
        didSet {
            if let old = oldValue, old.superview != nil, currentSearchBarPosition != nil {
                animateOutSearch(oldValue)
            } else if currentSearchBar != nil, currentSearchBarPosition != nil {
                animateInSearchBar()
            }
        }
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 67)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "Background")
        view.addSubview(collectionView)
        view.addSubview(languageImageView)
        view.addSubview(changeLanguageButton)
        linkBoxView.addSubview(linkLabel)
        view.addSubview(linkBoxView)

        adapter.dataSource = self

        resultsViewController.searchViewController = self

        DispatchQueue.main.async {
            let realm = try! Realm()

            let directions = realm.objects(MTRDirection.self).sorted(byKeyPath: "lastUsed", ascending: false)

            if directions.count > 0 {
                self.fromStation = directions[0].origin
                self.toStation = directions[0].destination
            }

            self.adapter.collectionView = self.collectionView
        }

        layoutUI()
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage),
                                               name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(LCLLanguageChangeNotification),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    @objc private func updateLanguage() {
        changeLanguageButton.setTitle("language".localized(), for: .normal)
    }

    private func layoutUI() {
        constrain(linkBoxView, linkLabel) { box, link in
            box.bottom == box.superview!.bottom - 48
            link.centerX == box.superview!.centerX
            box.leading == link.leading - 8
            box.trailing == link.trailing + 8
            link.bottom == box.bottom - 4
            box.top == link.top - 4
        }

        constrain(collectionView, changeLanguageButton, languageImageView, linkBoxView) {
            collection, language, languageIcon, box in

            collection.edges == collection.superview!.edges

            language.bottom == box.top
            language.centerX == language.superview!.centerX + 14
            language.height == 44

            languageIcon.trailing == language.leading + 4
            languageIcon.centerY == language.centerY

            languageIcon.height == language.height
            languageIcon.width == language.height
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @objc func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }

    func updateBottomLayoutConstraintWithNotification(_ notification: NSNotification) {
        let userInfo = notification.userInfo!

        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
//        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey]
            // as! NSNumber).uint32Value << 16
//        let animationCurve = UIViewAnimationOptions.fromRaw(UInt(rawAnimationCurve))!

//        NSLayoutConstraint
        guard let results = resultsViewController.view, results.superview != nil else { return }

        let value = view.bounds.maxY - convertedKeyboardEndFrame.minY
        constrain(resultsViewController.view, replace: currentSearchBarConstraintGroup) { results in
            results.bottom == results.superview!.bottom - value
        }

        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

class MTRSearchInputSection: NSObject, ListDiffable {
    func diffIdentifier() -> NSObjectProtocol { return self as NSObjectProtocol }
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool { return isEqual(object) }
}

extension MTRSearchViewController: ListAdapterDataSource {
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [
            MTRSearchInputSection()
        ]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return MTRSearchInputSectionController()
    }
}

final class MTRSearchInputSectionController: ListSectionController, ListSupplementaryViewSource {
    override init() {
        super.init()
        supplementaryViewSource = self
    }

    override func numberOfItems() -> Int {
        return 1
    }

    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        let cell = collectionContext!.dequeueReusableSupplementaryView(ofKind: elementKind,
                                                                       for: self,
                                                                       class: UICollectionViewCell.self, at: index)
        cell.translatesAutoresizingMaskIntoConstraints = false
        return cell
    }

    func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader]
    }

    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        let device = Device.current
        return CGSize(width: collectionContext!.containerSize.width, height: device.diagonal <= 4 ? 80 : 122)
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 50)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: MTRSearchInputCell.self,
                                                          for: self,
                                                          at: index) as! MTRSearchInputCell

        let searchViewController = viewController as? MTRSearchViewController
        searchViewController?.fromStation?.locale = Locale(rawValue: Localize.currentLanguage())!
        searchViewController?.toStation?.locale = Locale(rawValue: Localize.currentLanguage())!

        cell.fromTextInputView.text = searchViewController?.fromStation?.value
        cell.toTextInputView.text = searchViewController?.toStation?.value
        cell.getDirectionsButton.isEnabled =
            searchViewController?.fromStation != nil && searchViewController?.toStation != nil
        cell.delegate = searchViewController

        return cell
    }
}
