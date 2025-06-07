//
//  RaceViewModel.swift
//  HorseRacing
//
//  Created by Maxim on 05.06.2025.
//

import Foundation
import Dependencies
import SwiftUI


@Observable
class RaceViewModel {
    
    // MARK: - Dependencies
    
    @ObservationIgnored
    @Dependency(\.raceClient) var raceClient

    // MARK: - Public State
    
    let participants: [RaceParticipant] = .defaultValue
    var distance: Double = 100
    var liveRace: LiveRace?
    var raceParticipantModels: [RaceParticipantModel] = []
    var isRaceFinished = false
    var isRaceStarted: Bool { raceTask != nil }
    
    var raceTask: Task<Void, Never>?
    
    struct RaceParticipantModel: Identifiable, Equatable {
        let id: Int
        let name: String
        let number: Int
        let position: Double
        let speed: Double
        let isFinished: Bool
        var place: Int?
    }

    // MARK: - Init
    
    init() {
        prepareRace()
    }

    // MARK: - Actions
    
    func start() {
        guard raceTask == nil else { return }
        prepareRace()
        
        raceTask = Task {
            await startRace()
            raceTask = nil
            liveRace = nil
        }
    }

    func reset() {
        raceTask?.cancel()
        raceTask = nil
        raceParticipantModels = []
        isRaceFinished = false
        liveRace = nil
    }
    
    func restart() {
        reset()
        start()
    }

    // MARK: - Private Functions
    
    private func prepareRace() {
        let liveRace = LiveRace(
            id: UUID().uuidString,
            startDate: .now,
            endDate: nil,
            distance: distance,
            participants: participants
        )
        self.liveRace = liveRace
        
        raceParticipantModels = liveRace.participants.map { participant in
            return RaceParticipantModel(
                id: participant.id,
                name: participant.horse.name,
                number: participant.number,
                position: .zero,
                speed: 0,
                isFinished: false,
                place: nil
            )
        }
    }
    
    @MainActor
    private func startRace() async {
        guard let liveRace else { return }        
        for await update in raceClient.startRace(liveRace) {
            raceParticipantModels = update.updates
                .compactMap { state in
                    guard let participant = participants.first(where: { $0.id == state.participantId })
                    else { return nil }
                    
                    return RaceParticipantModel(
                        id: state.participantId,
                        name: participant.horse.name,
                        number: participant.number,
                        position: state.position,
                        speed: state.speed,
                        isFinished: state.finished,
                        place: state.place
                    )
                }
                .sorted { $0.number < $1.number }
        }
        
        guard Task.isCancelled == false else { return }
        isRaceFinished = true
    }
}
