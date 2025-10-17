//
//  GameModeModel.swift
//  FindNine
//
//  Created by Zhao on 2025/10/16.
//

import Foundation

enum GameMode: String, Codable {
    case timed = "Timed Mode"
    case endless = "Endless Mode"

    func displayName() -> String {
        switch self {
        case .timed:
            return "Timed Mode"
        case .endless:
            return "Endless Challenge"
        }
    }

    func description() -> String {
        switch self {
        case .timed:
            return "60 seconds to score as many points as possible"
        case .endless:
            return "Keep playing until you make a mistake"
        }
    }
}
