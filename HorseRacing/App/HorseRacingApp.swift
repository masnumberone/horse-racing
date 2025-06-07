//
//  HorseRacingApp.swift
//  HorseRacing
//
//  Created by Maxim on 05.06.2025.
//

import SwiftUI
import SFSafeSymbols

@main
struct HorseRacingApp: App {
    
    @State var mainFlowVM = MainFlowViewModel.defaultVM
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            MainFlowView(vm: mainFlowVM)
        }
    }
}

// MARK: - Preview

#Preview("App") {
    MainFlowView(
        vm: .defaultVM
    )
}
