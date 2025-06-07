//
//  RaceScreen.swift
//  HorseRacing
//
//  Created by Maxim on 05.06.2025.
//

import Foundation
import SwiftUI

struct RaceScreen: View {
    
    @Bindable var vm: RaceViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Лошадиные скачки")
                .font(.title)
                .bold()

            ScrollView {
                ForEach(vm.raceParticipantModels) { raceParticipantModel in
                    participantView(for: raceParticipantModel)
                        .padding(.horizontal)
                }
                .id(vm.liveRace?.id)
            }
            
            VStack {
                if vm.isRaceStarted {
                    Button("Отменить заезд") {
                        vm.reset()
                    }
                    .tint(.red)
                    .padding(.top)
                    
                } else if vm.isRaceFinished {
                    Button("Начать заезд заново") {
                        vm.restart()
                    }
                    .padding(.top)
                    
                } else {
                    Button("Начать заезд!") {
                        vm.start()
                    }
                    .padding(.top)
                }
            }
            .padding(.bottom, 24)
        }
        .padding()
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private func participantView(for model: RaceViewModel.RaceParticipantModel) -> some View {
        VStack(alignment: .leading, spacing: 4) {
             HStack {
                 Text(model.name)
                     .font(.headline)
                 
                 Spacer()
                 
                 if let place = model.place {
                     let isFinishedFirstPlace = vm.distance == model.position && place == 1
                     Text("#\(place)")
                         .foregroundStyle(isFinishedFirstPlace ? .green : .black)
                         .underline(isFinishedFirstPlace)
                         .contentTransition(.numericText())
                         .animation(.default, value: place)
                 }
             }

             HStack {
                 Text(String(format: "%.1f м/с", model.speed))
                     .foregroundColor(.secondary)
                 
                 Spacer()
                 
                 Text(String(format: "%.0f м", model.position))
                     .foregroundColor(.secondary)
             }
             .font(.subheadline)

             ProgressView(value: model.position, total: vm.distance)
                 .tint(model.isFinished ? .green : .blue)
                 .animation(.default, value: model.position)
         }
         .padding(.vertical, 4)
    }
}
