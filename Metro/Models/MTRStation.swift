//
//  MTRStation.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2018-07-28.
//  Copyright © 2018 Iaroslav Mamalat. All rights reserved.
//

import Foundation
import RealmSwift

//class MTRStation {
//    var id = ""
//    var name = ""
//
//    var lineIndex = 0
//    var lineId = ""
//
//    var connectionId: String?
//
//    // TODO: Add info model
//
//    var line: MTRLine? {
//        // TODO: Check realm
//        // OR: Dummy missing model
//        return MTRLine()
//    }
//
//    var connection: MTRStation? {
//        // TODO: Check realm
//        return MTRStation()
//    }
//}

enum Locale: String {
    case English = "en"
    case Russian = "ru"
    case Ukrainian = "uk"
}

class RealmLocale: Object {
    var locale: Locale {
        get { return Locale(rawValue: localeString)! }
        set { localeString = newValue.rawValue }
    }
    @objc dynamic var localeString = Locale.English.rawValue
}

class TranslatedString: Object {
    @objc dynamic var locale: RealmLocale? = RealmLocale()
    @objc dynamic var value = ""
}

class LocaleString: Object {
    var locale = Locale.English
    let translations = List<TranslatedString>()
    var value: String {
        return translations.filter("locale.localeString = %@", locale.rawValue).first!.value
    }
}

class MTRStation: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var lineIndex = 0
    @objc dynamic var lineId = ""
    @objc dynamic var connectionId: String?

    var locale = Locale.English
    let translations = List<TranslatedString>()
    var value: String {
        guard let locale = translations.filter("locale.localeString = %@", locale.rawValue).first else {
            return name
        }
        return locale.value
    }

    //    dynamic var favorite = false
    //    dynamic var lastUsed = NSData()

    //    dynamic var line: MTRLine?
    //    dynamic var connection: MTRStation?

    var line: MTRLine? {
        get {
            let realm = try? Realm()
            return realm?.object(ofType: MTRLine.self, forPrimaryKey: self.lineId)
        }
    }

    var connection: MTRStation? {
        get {
            let realm = try? Realm()
            guard let _connectionId = self.connectionId else { return nil }
            return realm?.object(ofType: MTRStation.self, forPrimaryKey: _connectionId)
        }
    }

    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lng: Double = 0.0

    override static func primaryKey() -> String? {
        return "id"
    }

    override static func indexedProperties() -> [String] { return ["id"] }

    convenience init(_ name: String, line: MTRLine, lineIndex: Int = 0) {
        self.init()
        self.name = name
        self.lineId = line.id
        self.id = "\(line.id)_\(lineIndex)"
        self.lineIndex = lineIndex
        //        self.line = line
    }
}

//extension MTRStation: Equatable {
//    static func ==(lhs: MTRStation, rhs: MTRStation) -> Bool {
//        return lhs.id == rhs.id
//    }
//}
