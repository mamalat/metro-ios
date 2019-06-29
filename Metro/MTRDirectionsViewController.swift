//
//  MTRDirectionsViewController.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2019-06-20.
//  Copyright © 2019 Iaroslav Mamalat. All rights reserved.
//

import UIKit
import IGListKit
import Cartography

class MTRDirectionsViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 120)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    var stations: [MTRStation] {
        didSet {
            adapter.performUpdates(animated: true)
        }
    }

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    init(stations: [MTRStation]) {
        self.stations = stations
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        adapter.dataSource = self
        adapter.collectionView = collectionView

        view.backgroundColor = UIColor(named: "White")
        view.addSubview(collectionView)

        navigationItem.title = "directions".localized()
        navigationItem.backBarButtonItem = nil
        navigationController?.navigationBar.tintColor = UIColor(named: "Black")
        layoutUI()
    }

    private func layoutUI() {
        constrain(collectionView) {
            $0.edges == $0.superview!.edges
        }
    }
}

extension MTRDirectionsViewController: ListAdapterDataSource {
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        
        var items: [ListDiffable] = []
        var changedStation = false

        for (index, station) in stations.enumerated() {

            if (index + 1) < stations.count {
                let nextStation = stations[index + 1]
                if station.lineId != nextStation.lineId {
                    changedStation = true
                    items.append(MTRDirectionsChangeStationsSection(station, to: nextStation))
                    continue
                }
            }

            if changedStation {
                changedStation = false
                continue
            }

            items.append(MTRDirectionsStationSection(station))
        }

        return items
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        // refactor
        switch object {
            case is MTRDirectionsChangeStationsSection: return MTRDirectionsChangeSectionController()
            default: return MTRDirectionsSectionController()
        }
    }
}
class MTRDirectionsStationSection: NSObject, ListDiffable {
    let station: MTRStation

    init(_ station: MTRStation) { self.station = station }

    func diffIdentifier() -> NSObjectProtocol { return self as NSObjectProtocol }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool { return isEqual(object) }
}

class MTRDirectionsChangeStationsSection: NSObject, ListDiffable {
    let from: MTRStation
    let to: MTRStation

    init(_ from: MTRStation, to: MTRStation) {
        self.from = from
        self.to = to
    }

    func diffIdentifier() -> NSObjectProtocol { return self as NSObjectProtocol }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool { return isEqual(object) }
}

final class MTRDirectionsSectionController: ListSectionController {
    var item: MTRDirectionsStationSection?
//
//    override init() {
//        super.init()
//        supplementaryViewSource = self
//    }
////
//    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
//        let cell = collectionContext!.dequeueReusableSupplementaryView(ofKind: elementKind,
// for: self, class: UICollectionViewCell.self, at: index)
//        cell.translatesAutoresizingMaskIntoConstraints = false
//        return cell
//    }

//    func supportedElementKinds() -> [String] {
//        return [UICollectionElementKindSectionFooter]
//    }
//
//    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
//        return CGSize(width: collectionContext!.containerSize.width, height: 60)
//    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func didUpdate(to object: Any) { self.item = object as? MTRDirectionsStationSection }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 67)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: MTRDirectionStationCell.self, for: self, at: index) as! MTRDirectionStationCell
        if let station = item?.station { cell.set(station) }
        cell.lineView.alpha = isLastSection ? 0 : 1
        return cell
    }
}

final class MTRDirectionsChangeSectionController: ListSectionController {
    var item: MTRDirectionsChangeStationsSection?

    override func numberOfItems() -> Int {
        return 1
    }

    override func didUpdate(to object: Any) { self.item = object as? MTRDirectionsChangeStationsSection }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 120)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: MTRDirectionChangeStationCell.self, for: self, at: index) as! MTRDirectionChangeStationCell
        if let from = item?.from, let to = item?.to {
            cell.set(from, toStation: to)
        }
        cell.lineView.alpha = isLastSection ? 0 : 1
        return cell
    }
}
