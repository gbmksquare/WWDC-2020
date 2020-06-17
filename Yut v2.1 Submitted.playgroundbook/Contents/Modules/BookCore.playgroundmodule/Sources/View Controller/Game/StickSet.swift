//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation
import os.log

public struct StickSet {
    public enum RollResult: String, CustomDebugStringConvertible {
        case `do`, gae, gir, yut, mo, backDo
        
        var name: String {
            return rawValue.capitalized
        }
        
        var localizedName: String {
            switch self {
            case .backDo: return "빽도"
            case .do: return "도"
            case .gae: return "개"
            case .gir: return "걸"
            case .yut: return "윷"
            case .mo: return "모"
            }
        }
        
        public var steps: Int {
            switch self {
            case .backDo: return -1
            case .do: return 1
            case .gae: return 2
            case .gir: return 3
            case .yut: return 4
            case .mo: return 5
            }
        }
        
        public var canRollOneMoreTime: Bool {
            switch self {
            case .yut, .mo: return true
            default: return false
            }
        }
        
        // MARK: - Debug
        public var debugDescription: String {
            #if canImport(PlaygroundSupport)
            return name
            #else
            return localizedName
            #endif
        }
    }
    
    public let sticks = [Stick(),
                         Stick(),
                         Stick(),
                         Stick(isMarked: true)]
    
    // MARK: - Action
    public func roll() -> (StickSet.RollResult, [Stick.RollResult]) {
        let results = sticks.map { $0.roll() }.shuffled()
        let setResult = StickSet.getSetResult(from: results)
        os_log(.debug, log: .game, "%{PUBLIC}@!, %{PUBLIC}@", setResult.debugDescription, results.debugDescription)
        if setResult.canRollOneMoreTime {
            os_log(.debug, log: .game, "한 번 더!")
        }
        return (setResult, results)
    }
    
    static func getSetResult(from results: [Stick.RollResult]) -> StickSet.RollResult {
        let backs = results.filter { $0 == .back }
        let backCount = backs.count
        if backCount == 0 {
            return .yut
        } else if backCount == 1{
            return .gir
        } else if backCount == 2 {
            return .gae
        } else if backCount == 3 && results.contains(.frontMarked) {
            return .backDo
        } else if backCount == 3 {
            return .do
        } else {
            return .mo
        }
    }
}
