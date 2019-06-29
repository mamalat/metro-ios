//
//  MTRMapViewController.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2019-06-27.
//  Copyright © 2019 Iaroslav Mamalat. All rights reserved.
//

import UIKit
import MapKit
import Cartography

class MTRMapViewController: UIViewController {

    lazy var mapView: MKMapView = {
        let map = MKMapView()
//        m.isZoomEnabled = false
        let camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(
            latitude: CLLocationDegrees(59.4112856),
            longitude: CLLocationDegrees(17.897166)),
            fromDistance: CLLocationDistance(2000),
            pitch: 0.1,
            heading: .zero // CLLocationDirection(floatLiteral: 0)
        )
        map.setCamera(camera, animated: true)
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)

        layoutUI()
    }

    private func layoutUI() {
        constrain(mapView) { map in
            map.edges == map.superview!.edges
        }
    }
}
