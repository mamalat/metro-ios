//
//  MTRDirection.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2019-06-21.
//  Copyright © 2019 Iaroslav Mamalat. All rights reserved.
//

import Foundation
import RealmSwift

class MTRDirection: Object {
    @objc dynamic var id = "" // \(origin.id)_\(destination.id)
    @objc dynamic var favorite = false
    @objc dynamic var lastUsed = Date()
    @objc dynamic var destinationId: String?
    @objc dynamic var originId: String?

    var destination: MTRStation? {
        get {
            let realm = try? Realm()
            guard let connectionId = self.destinationId else { return nil }
            return realm?.object(ofType: MTRStation.self, forPrimaryKey: connectionId)
        }
    }

    var origin: MTRStation? {
        get {
            let realm = try? Realm()
            guard let connectionId = self.originId else { return nil }
            return realm?.object(ofType: MTRStation.self, forPrimaryKey: connectionId)
        }
    }

    convenience init(_ origin: MTRStation, destination: MTRStation) {
        self.init()
        self.id = "\(origin.id)_\(destination.id)"
        self.destinationId = destination.id
        self.originId = origin.id
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    override static func indexedProperties() -> [String] {
        return ["id"]
    }
}
