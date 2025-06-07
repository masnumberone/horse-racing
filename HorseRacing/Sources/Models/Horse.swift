//
//  Horse.swift
//  HorseRacing
//
//  Created by Maxim on 07.06.2025.
//

import Foundation

struct Horse: Identifiable {
    let id: Int
    let name: String
    let speedFactor: Double = { Double.random(in: 0.8...1.2) }()
}
