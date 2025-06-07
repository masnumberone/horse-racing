//
//  RaceClient.swift
//  HorseRacing
//
//  Created by Maxim on 07.06.2025.
//

import Foundation
import Dependencies
import Sharing

struct RaceClient {
    var startRace: @Sendable (LiveRace) -> AsyncStream<RaceUpdate>
}

extension RaceClient: DependencyKey {
    static let liveValue: RaceClient = {
        @Shared(.finishedRaces) var raceHistory: [FinishedRace] = []
        
        return RaceClient(
            startRace: { [$raceHistory] liveRace in
                AsyncStream { continuation in
                    let updateInterval: TimeInterval = 0.2
                    let distance = liveRace.distance
                    let startTime = Date()
                    var endTime: Date?
                    
                    var states: [Int: ParticipantLiveState] = Dictionary(
                        uniqueKeysWithValues: liveRace.participants.map {
                            (
                                $0.number,
                                ParticipantLiveState(
                                    participantId: $0.number,
                                    speed: 0,
                                    position: 0,
                                    finished: false,
                                    place: 0,
                                    finishTime: nil
                                )
                            )
                        }
                    )
                    
                    let timer = DispatchSource.makeTimerSource()
                    timer.schedule(deadline: .now(), repeating: updateInterval)
                    
                    timer.setEventHandler {
                        let now = Date()
                        var allFinished = true
                        
                        for participant in liveRace.participants {
                            var state = states[participant.number]!
                            guard !state.finished else { continue }
                            
                            let baseSpeed = Double.random(in: 15...20)
                            let speedFactor = liveRace.participants
                                .first { $0.number == state.participantId }?
                                .horse.speedFactor ?? 1.0
                            
                            let speed = baseSpeed * speedFactor
                            state.speed = speed
                            state.position += speed * updateInterval
                            
                            if state.position >= distance {
                                state.position = distance
                                state.finished = true
                                state.finishTime = now
                            } else {
                                allFinished = false
                            }
                            
                            states[participant.number] = state
                        }
                        
                        let finished = states.values
                            .filter { $0.finished && $0.finishTime != nil }
                            .sorted {
                                if $0.finishTime! != $1.finishTime! {
                                    return $0.finishTime! < $1.finishTime!
                                } else {
                                    return $0.speed > $1.speed
                                }
                            }                        
                        
                        let inProgress = states.values
                            .filter { !$0.finished }
                            .sorted { $0.position > $1.position }
                        
                        var placeCounter = 1
                        var updatedStates: [Int: ParticipantLiveState] = [:]
                        
                        for var state in finished {
                            state.place = placeCounter
                            updatedStates[state.participantId] = state
                            placeCounter += 1
                        }
                        
                        for var state in inProgress {
                            state.place = placeCounter
                            updatedStates[state.participantId] = state
                            placeCounter += 1
                        }
                        
                        states = updatedStates
                        
                        continuation.yield(
                            RaceUpdate(timestamp: now, updates: Array(states.values))
                        )
                        
                        if allFinished {
                            endTime = now
                            continuation.finish()
                            timer.cancel()
                            
                            let raceResults = finished.map { state -> RaceResult in
                                let horse = liveRace.participants.first { $0.number == state.participantId }!.horse
                                let time = state.finishTime?.timeIntervalSince(startTime) ?? 0
                                return RaceResult(
                                    id: state.participantId,
                                    name: horse.name,
                                    place: state.place,
                                    time: time
                                )
                            }
                            
                            let finishedRace = FinishedRace(
                                id: liveRace.id,
                                startDate: startTime,
                                endDate: endTime!,
                                distance: distance,
                                results: raceResults
                            )
                            
                            $raceHistory.withLock { $0.append(finishedRace) }
                        }
                    }
                    
                    timer.resume()
                    
                    continuation.onTermination = { _ in
                        timer.cancel()
                    }
                }
            }
        )
    }()
}

// MARK: - Dependency Value

extension DependencyValues {
    var raceClient: RaceClient {
        get { self[RaceClient.self] }
        set { self[RaceClient.self] = newValue }
    }
}
