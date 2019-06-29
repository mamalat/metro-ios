//
//  MTRLine.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2018-07-28.
//  Copyright © 2018 Iaroslav Mamalat. All rights reserved.
//

import Foundation
import RealmSwift

class MTRLine: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    //    dynamic var number = 0 (1,2,3)
    //    dynamic var color

    override static func primaryKey() -> String? { return "id" }
    override static func indexedProperties() -> [String] { return ["id"] }

    convenience init(_ name: String, id: String) {
        self.init()
        self.name = name
        self.id = id
    }

    var stations: Results<MTRStation> {
        get {
            let realm = try! Realm()
            return realm.objects(MTRStation.self).filter("lineId = '\(self.id)'").sorted(byKeyPath: "lineIndex")
        }
    }
}

//extension MTRLine: Equatable {
//    static func ==(lhs: MTRLine, rhs: MTRLine) -> Bool {
//        return lhs.id == rhs.id
//    }
//}
