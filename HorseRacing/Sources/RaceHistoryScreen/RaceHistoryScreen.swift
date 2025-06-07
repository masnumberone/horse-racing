//
//  RaceHistoryScreen.swift
//  HorseRacing
//
//  Created by Maxim on 05.06.2025.
//

import Foundation
import SwiftUI

struct RaceHistoryScreen: View {

    var vm: RaceHistoryViewModel
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack {
                if vm.raceHistory.isEmpty {
                    HStack {
                        Image(systemSymbol: .clock)
                        Text("Нет заездов")
                    }
                    
                } else {
                    List {
                        ForEach(vm.enumeratedRaceHistory, id: \.0) { (index, race) in
                            Section {
                                raceItemView(race)
                            }
                            header: {
                                raceItemHeader(race, number: index + 1)
                            }
                        }
                    }
                }
            }
            .animation(.default, value: vm.enumeratedRaceHistory.map(\.0))
            .navigationTitle("История скачек")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !vm.raceHistory.isEmpty {
                        Button("Очистить", role: .destructive) {
                            vm.clearHistory()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Views
    
    private func raceItemHeader(_ race: FinishedRace, number: Int) -> some View {
        HStack {
            Text("Заезд \(number)")
            Spacer()
            Text(race.startDate.formatted(date: .numeric, time: .shortened))
                .foregroundColor(.secondary)
        }
    }
    
    private func raceItemView(_ race: FinishedRace) -> some View {
        ForEach(race.results.sorted(by: { $0.place < $1.place })) { result in
            HStack {
                Text("#\(result.place)")
                    .frame(width: 40, alignment: .leading)
                
                Text(result.name)
                
                Spacer()
                
                Text(result.time.formatted(.number.precision(.fractionLength(2)))) + Text(" с")
                    .foregroundColor(.secondary)
            }
        }
    }
}
