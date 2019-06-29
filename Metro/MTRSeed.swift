//
//  MTRSeed.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2019-06-21.
//  Copyright © 2019 Iaroslav Mamalat. All rights reserved.
//

import RealmSwift
import Foundation

class MTRSeed {

//    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TemporaryRealm"))
//
//    realm.beginWrite()
//    let en = RealmLocale()
//    en.locale = .English
//    let fr = RealmLocale()
//    fr.locale = .French
//    let grapefruit = TranslatedString()
//    grapefruit.locale = en
//    grapefruit.value = "grapefruit"
//    let pamplemousse = TranslatedString()
//    pamplemousse.locale = fr
//    pamplemousse.value = "pamplemousse"
//    let translatedGrapefruit = LocaleString()
//    translatedGrapefruit.translations.appendContentsOf([grapefruit, pamplemousse])
//    realm.add(translatedGrapefruit)
//    try! realm.commitWrite()
//
//    translatedGrapefruit.value // => 'grapefruit'
//    translatedGrapefruit.locale = .French
//    translatedGrapefruit.value // => 'pamplemousse'

    static let shared = MTRSeed()

    func stationTranslations(_ station: MTRStation, traslations: [String]) -> MTRStation {
        
        let english = RealmLocale()
        english.locale = .English
        let russian = RealmLocale()
        russian.locale = .Russian
        let ukrainian = RealmLocale()
        ukrainian.locale = .Ukrainian

        traslations.enumerated().forEach { (index, element) in
            let translation = TranslatedString()
            translation.locale = [english, russian, ukrainian][index]
            translation.value = element
            station.translations.append(translation)
        }

        return station
    }

    func seed() {
        let realm = try? Realm()
        
        let redLine = MTRLine("Sviatoshynsko-Brovarska", id: "red")

        let greenLine = MTRLine("Syretsko-Pecherska", id: "green")
        
        let blueLine = MTRLine("Kurenivsko-Chervonoarmiyska", id: "blue")

        // MARK: Green Line

        var greenStations = [MTRStation]()
        
        let khreshchatyk = stationTranslations(MTRStation("Khreshchatyk", line: redLine, lineIndex: 10), traslations: ["Khreshchatyk", "Крещатик", "Хрещатик"])
        let maidan = stationTranslations(MTRStation("Maidan Nezalezhnosti", line: blueLine, lineIndex: 7), traslations: ["Maidan Nezalezhnosti", "Площадь Независимости", "Майдан Незалежності"])
        
        khreshchatyk.connectionId = maidan.id
        maidan.connectionId = khreshchatyk.id

        let palats = stationTranslations(MTRStation("Palats Sportu", line: greenLine, lineIndex: 4), traslations: ["Palats Sportu", "Дворец спорта", "Палац спорту"])
        let lva = stationTranslations(MTRStation("Ploscha Lva Tolstoho", line: blueLine, lineIndex: 8), traslations: ["Ploscha Lva Tolstoho", "Площадь Льва Толстого", "Площа Льва Толстого"])

        palats.connectionId = lva.id
        lva.connectionId = palats.id

        let teatralna = stationTranslations(MTRStation("Teatralna", line: redLine, lineIndex: 9), traslations: ["Teatralna", "Театральная", "Театральна"])
        let zoloti = stationTranslations(MTRStation("Zoloti Vorota", line: greenLine, lineIndex: 3), traslations: ["Zoloti Vorota", "Золотые ворота", "Золоті Ворота"])

        teatralna.connectionId = zoloti.id
        zoloti.connectionId = teatralna.id

        greenStations.append(stationTranslations(MTRStation("Syrets", line: greenLine, lineIndex: 0), traslations: ["Syrets", "Сырец", "Сирець"]))
        greenStations.append(stationTranslations(MTRStation("Dorohozhychi", line: greenLine, lineIndex: 1), traslations: ["Dorohozhychi", "Дорогожичи", "Дорогожичі"]))
        greenStations.append(stationTranslations(MTRStation("Lukianivska", line: greenLine, lineIndex: 2), traslations: ["Lukianivska", "Лукьяновская", "Лук'янівська"]))
        greenStations.append(zoloti)
        greenStations.append(palats)
        greenStations.append(stationTranslations(MTRStation("Klovska", line: greenLine, lineIndex: 5), traslations: ["Klovska", "Кловская", "Кловська"]))
        greenStations.append(stationTranslations(MTRStation("Pecherska", line: greenLine, lineIndex: 6), traslations: ["Pecherska", "Печерская", "Печерська"]))
        greenStations.append(stationTranslations(MTRStation("Druzhby Narodiv", line: greenLine, lineIndex: 7), traslations: ["Druzhby Narodiv", "Дружбы народов", "Дружби народів"]))
        greenStations.append(stationTranslations(MTRStation("Vydubychi", line: greenLine, lineIndex: 8), traslations: ["Vydubychi", "Выдубичи", "Видубичі"]))
        greenStations.append(stationTranslations(MTRStation("Slavutych", line: greenLine, lineIndex: 9), traslations: ["Slavutych", "Славутич", "Славутич"]))
        greenStations.append(stationTranslations(MTRStation("Osokorky", line: greenLine, lineIndex: 10), traslations: ["Osokorky", "Осокорки", "Осокорки"]))
        greenStations.append(stationTranslations(MTRStation("Pozniaky", line: greenLine, lineIndex: 11), traslations: ["Pozniaky", "Позняки", "Позняки"]))
        greenStations.append(stationTranslations(MTRStation("Kharkivska", line: greenLine, lineIndex: 12), traslations: ["Kharkivska", "Харьковская", "Харківська"]))
        greenStations.append(stationTranslations(MTRStation("Vyrlytsia", line: greenLine, lineIndex: 13), traslations: ["Vyrlytsia", "Вырлица", "Вирлиця"]))
        greenStations.append(stationTranslations(MTRStation("Boryspilska", line: greenLine, lineIndex: 14), traslations: ["Boryspilska", "Бориспольская", "Бориспільська"]))
        greenStations.append(stationTranslations(MTRStation("Chervony Khutir", line: greenLine, lineIndex: 15), traslations: ["Chervony Khutir", "Красный хутор", "Червоний Хутір"]))
        
        // MARK: Blue line
        var blueStations = [MTRStation]()
        blueStations.append(stationTranslations(MTRStation("Heroiv Dnipra", line: blueLine, lineIndex: 0), traslations: ["Heroiv Dnipra", "Героев Днепра", "Героїв Дніпра"]))
        blueStations.append(stationTranslations(MTRStation("Minska", line: blueLine, lineIndex: 1), traslations: ["Minska", "Минская", "Мінська"]))
        blueStations.append(stationTranslations(MTRStation("Obolon", line: blueLine, lineIndex: 2), traslations: ["Obolon", "Оболонь", "Оболонь"]))
        blueStations.append(stationTranslations(MTRStation("Pochaina", line: blueLine, lineIndex: 3), traslations: ["Pochaina", "Почайна", "Почайна"]))
        blueStations.append(stationTranslations(MTRStation("Tarasa Shevchenka", line: blueLine, lineIndex: 4), traslations: ["Tarasa Shevchenka", "Тараса Шевченко", "Тараса Шевченка"]))
        blueStations.append(stationTranslations(MTRStation("Kontraktova Ploscha", line: blueLine, lineIndex: 5), traslations: ["Kontraktova Ploscha", "Контрактовая площадь", "Контрактова площа"]))
        blueStations.append(stationTranslations(MTRStation("Poshtova Ploscha", line: blueLine, lineIndex: 6), traslations: ["Poshtova Ploscha", "Почтовая площадь", "Поштова площа"]))
        blueStations.append(maidan)
        blueStations.append(lva)
        blueStations.append(stationTranslations(MTRStation("Olimpiiska", line: blueLine, lineIndex: 9), traslations: ["Olimpiiska", "Олимпийская", "Олімпійська"]))
        blueStations.append(stationTranslations(MTRStation("Palats Ukraina", line: blueLine, lineIndex: 10), traslations: ["Palats Ukraina", "Дворец Украина", "Палац \"Україна\""]))
        blueStations.append(stationTranslations(MTRStation("Lybidska", line: blueLine, lineIndex: 11), traslations: ["Lybidska", "Лыбедская", "Либідська"]))
        blueStations.append(stationTranslations(MTRStation("Demiivska", line: blueLine, lineIndex: 12), traslations: ["Demiivska", "Демиевская", "Деміївська"]))
        blueStations.append(stationTranslations(MTRStation("Holosiivska", line: blueLine, lineIndex: 13), traslations: ["Holosiivska", "Голосеевская", "Голосіївська"]))
        blueStations.append(stationTranslations(MTRStation("Vasylkivska", line: blueLine, lineIndex: 14), traslations: ["Vasylkivska", "Васильковская", "Васильківська"]))
        blueStations.append(stationTranslations(MTRStation("Vystavkovyi Tsentr", line: blueLine, lineIndex: 15), traslations: ["Vystavkovyi Tsentr", "Выставочный центр", "Виставковий центр"]))
        blueStations.append(stationTranslations(MTRStation("Ipodrom", line: blueLine, lineIndex: 16), traslations: ["Ipodrom", "Ипподром", "Іподром"]))
        blueStations.append(stationTranslations(MTRStation("Teremky", line: blueLine, lineIndex: 17), traslations: ["Teremky", "Теремки", "Теремки"]))

        // MARK: Red line
        var redStations = [MTRStation]()
        redStations.append(stationTranslations(MTRStation("Akademmistechko", line: redLine, lineIndex: 0), traslations: ["Akademmistechko", "Академгородок", "Академмістечко"]))
        redStations.append(stationTranslations(MTRStation("Zhytomyrska", line: redLine, lineIndex: 1), traslations: ["Zhytomyrska", "Житомирская", "Житомирська"]))
        redStations.append(stationTranslations(MTRStation("Sviatoshyn", line: redLine, lineIndex: 2), traslations: ["Sviatoshyn", "Святошин", "Святошин"]))
        redStations.append(stationTranslations(MTRStation("Nyvky", line: redLine, lineIndex: 3), traslations: ["Nyvky", "Нивки", "Нивки"]))
        redStations.append(stationTranslations(MTRStation("Beresteiska", line: redLine, lineIndex: 4), traslations: ["Beresteiska", "Берестейская", "Берестейська"]))
        redStations.append(stationTranslations(MTRStation("Shuliavska", line: redLine, lineIndex: 5), traslations: ["Shuliavska", "Шулявская", "Шулявська"]))
        redStations.append(stationTranslations(MTRStation("Politekhnichnyi Instytut", line: redLine, lineIndex: 6), traslations: ["Politekhnichnyi Instytut", "Политехнический институт", "Політехнічний інститут"]))
        redStations.append(stationTranslations(MTRStation("Vokzalna", line: redLine, lineIndex: 7), traslations: ["Vokzalna", "Вокзальная", "Вокзальна"]))
        redStations.append(stationTranslations(MTRStation("Universytet", line: redLine, lineIndex: 8), traslations: ["Universytet", "Университет", "Університет"]))
        redStations.append(teatralna)
        redStations.append(khreshchatyk)
        redStations.append(stationTranslations(MTRStation("Arsenalna", line: redLine, lineIndex: 11), traslations: ["Arsenalna", "Арсенальная", "Арсенальна"]))
        redStations.append(stationTranslations(MTRStation("Dnipro", line: redLine, lineIndex: 12), traslations: ["Dnipro", "Днепр", "Дніпро"]))
        redStations.append(stationTranslations(MTRStation("Hidropark", line: redLine, lineIndex: 13), traslations: ["Hidropark", "Гидропарк", "Гідропарк"]))
        redStations.append(stationTranslations(MTRStation("Livoberezhna", line: redLine, lineIndex: 14), traslations: ["Livoberezhna", "Левобережная", "Лівобережна"]))
        redStations.append(stationTranslations(MTRStation("Darnytsia", line: redLine, lineIndex: 15), traslations: ["Darnytsia", "Дарница", "Дарниця"]))
        redStations.append(stationTranslations(MTRStation("Chernihivska", line: redLine, lineIndex: 16), traslations: ["Chernihivska", "Черниговская", "Чернігівська"]))
        redStations.append(stationTranslations(MTRStation("Lisova", line: redLine, lineIndex: 17), traslations: ["Lisova", "Лесная", "Лісова"]))

        try? realm?.write {
            realm?.add(greenLine)
            realm?.add(blueLine)
            realm?.add(redLine)
            realm?.add(greenStations)
            realm?.add(blueStations)
            realm?.add(redStations)
        }
    }
}
