//
//  MainFlowView.swift
//  HorseRacing
//
//  Created by Maxim on 05.06.2025.
//

import SwiftUI

struct MainFlowView: View {
    
    @Bindable var vm: MainFlowViewModel
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            RaceScreen(vm: vm.raceViewModel)
                .tag(MainFlowViewModel.Tab.race)
                .tabItem {
                    Image(systemSymbol: .flagFilledAndFlagCrossed)
                    Text("Скачки")
                }
            
            RaceHistoryScreen(vm: vm.raceHistoryViewModel)
                .tag(MainFlowViewModel.Tab.raceHistory)
                .tabItem {
                    Image(systemSymbol: .chartBarXaxis)
                    Text("История")
                }
        }
    }
}
