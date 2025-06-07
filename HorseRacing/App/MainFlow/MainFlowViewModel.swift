//
//  AppViewModel.swift
//  HorseRacing
//
//  Created by Maxim on 05.06.2025.
//

import Foundation

@Observable
class MainFlowViewModel {
    
    enum Tab {
        case race
        case raceHistory
    }
    
    var selectedTab: Tab
    
    var raceViewModel: RaceViewModel
    var raceHistoryViewModel: RaceHistoryViewModel
    
    // MARK: - Init
    
    init(
        selectedTab: Tab,
        raceViewModel: RaceViewModel,
        raceHistoryViewModel: RaceHistoryViewModel
    ) {
        self.selectedTab = selectedTab
        self.raceViewModel = raceViewModel
        self.raceHistoryViewModel = raceHistoryViewModel
    }
}

// MARK: - Default View Model

extension MainFlowViewModel {
    static var defaultVM: MainFlowViewModel {
        .init(
            selectedTab: .race,
            raceViewModel: .init(),
            raceHistoryViewModel: .init()
        )
    }
}
