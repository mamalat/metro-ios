//
//  MTRDirectionFinder.swift
//  Metro
//
//  Created by Iaroslav Mamalat on 2018-07-28.
//  Copyright © 2018 Iaroslav Mamalat. All rights reserved.
//

import Foundation

// If Direction model was used, update it

//    let direction: MTRDirection

//    var destination: MTRStation {
//        get {
//            return direction.destination!
//        }
//    }
//
//    var origin: MTRStation {
//        get {
//            return direction.origin!
//        }
//    }

class MTRDirectionFinder {

    let origin: MTRStation
    let destination: MTRStation

    init(from origin: MTRStation, to destination: MTRStation) {
        self.destination = destination
        self.origin = origin
    }

    func getPath() -> [MTRStation] {
        guard
            let destinationLine = destination.line,
            let originLine = origin.line
            else { return [] }
        // TODO: Probably should throw error

        guard destinationLine != originLine
            else { return straightLine(originLine, from: origin, to: destination) }

        var directions = [MTRStation]()

        guard
            let change = findChangeStation(),
            let connection = change.connection
            else { return directions }

        directions += straightLine(originLine, from: origin, to: change)
        directions += straightLine(destinationLine, from: connection, to: destination)

        return directions
    }

    private func straightLine(_ line: MTRLine, from: MTRStation, to: MTRStation) -> [MTRStation] {

        var stations = [MTRStation]()
        var reverse = false

        guard
            var fromIndex = line.stations.index(where: { $0 == from }),
            var toIndex = line.stations.index(where: { $0 == to })
            else { return [] }

        if fromIndex > toIndex {
            reverse = true
            (toIndex, fromIndex) = (fromIndex, toIndex)
        }

        for station in line.stations[fromIndex...toIndex] {
            stations.append(station)
        }

        return reverse ? stations.reversed() : stations
    }

    private func findChangeStation () -> MTRStation? {
        guard
            let stations = origin.line?.stations
            else { return nil }

        for station in stations {
            guard
                let change = station.connection,
                change.line == destination.line
                else { continue }

            return station
        }

        return nil
    }
}
