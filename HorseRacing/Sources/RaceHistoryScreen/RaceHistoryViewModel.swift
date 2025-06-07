//
//  RaceHistoryViewModel.swift
//  HorseRacing
//
//  Created by Maxim on 05.06.2025.
//

import Foundation
import Sharing
import SwiftUI

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
    
    func requestPushPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { result, error in
            if let error  {
                print("Ошибка при запросе разрешения: \(error.localizedDescription)")
                return
            }
            print("Разрешение предоставлено: \(result)")
            guard result else { return }
            Task { @MainActor in
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
