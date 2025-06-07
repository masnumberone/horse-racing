//
//  Race.swift
//  HorseRacing
//
//  Created by Maxim on 07.06.2025.
//

import Foundation


// MARK: - Live Race

struct LiveRace: Identifiable {
    let id: String
    let startDate: Date
    var endDate: Date?
    let distance: Double
    let participants: [RaceParticipant]
}

struct RaceParticipant: Identifiable {
    let number: Int
    let horse: Horse
    
    var id: Int { number }
}

// MARK: - Race Update

struct RaceUpdate {
    let timestamp: Date
    let updates: [ParticipantLiveState]
}

struct ParticipantLiveState {
    let participantId: Int
    var speed: Double
    var position: Double
    var finished: Bool
    var place: Int
    var finishTime: Date?
}

// MARK: - FinishedRace

struct FinishedRace: Identifiable, Codable, Equatable {
    let id: String
    let startDate: Date
    let endDate: Date
    let distance: Double
    let results: [RaceResult]
}

struct RaceResult: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let place: Int
    let time: TimeInterval
}

// MARK: - Mock

extension Array where Element == RaceParticipant {
    static let defaultValue: [RaceParticipant] = [
        RaceParticipant(number: 1, horse: Horse(id: 1, name: "Молния")),
        RaceParticipant(number: 2, horse: Horse(id: 2, name: "Ракета")),
        RaceParticipant(number: 3, horse: Horse(id: 3, name: "Гром")),
        RaceParticipant(number: 4, horse: Horse(id: 4, name: "Тайфун")),
        RaceParticipant(number: 5, horse: Horse(id: 5, name: "Ветер")),
    ]
}
