//
//  FinishedRaces.swift
//  HorseRacing
//
//  Created by Maxim on 07.06.2025.
//

import Foundation
import Sharing

extension SharedReaderKey where Self == FileStorageKey<[FinishedRace]> {
    static var finishedRaces: Self {
        .fileStorage(
            URL.documentsDirectory.appending(path: String.finishedRacesJsonKey)
        )
    }
}

fileprivate extension String {
    static let finishedRacesJsonKey = "finished_races.json"
}
