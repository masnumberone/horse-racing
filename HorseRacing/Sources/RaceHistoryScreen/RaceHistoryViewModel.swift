//
//  RaceHistoryViewModel.swift
//  HorseRacing
//
//  Created by Maxim on 05.06.2025.
//

import Foundation
import Sharing

@Observable
class RaceHistoryViewModel {
    
    // MARK: - Dependencies
    
    @ObservationIgnored
    @Shared(.finishedRaces) var raceHistory: [FinishedRace] = []
    
    // MARK: - Public State
    
    var enumeratedRaceHistory: [(Int, FinishedRace)] {
        let enumeratedRaces = raceHistory
            .sorted { $0.startDate < $1.startDate }
            .enumerated()
            .reversed()
        
        return Array(enumeratedRaces)
    }
    
    // MARK: - Actions
 
    func clearHistory() {
        $raceHistory.withLock { $0.removeAll() }
    }
}
