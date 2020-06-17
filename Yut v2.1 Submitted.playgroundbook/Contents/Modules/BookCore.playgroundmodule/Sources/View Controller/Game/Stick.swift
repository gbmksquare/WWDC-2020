//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation

public struct Stick {
    public enum RollResult: String, CaseIterable, CustomDebugStringConvertible {
        case front, back, frontMarked
        
        var name: String {
            switch self {
            case .front: return "Front"
            case .back: return "Back"
            case .frontMarked: return "Front (Marked)"
            }
        }
        
        var localizedName: String {
            switch self {
            case .front: return "앞"
            case .back: return "뒤"
            case .frontMarked: return "앞 (백도)"
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
    
    public var isMarked = false
    
    // MARK: - Initialization
    public init(isMarked: Bool = false) {
        self.isMarked = isMarked
    }
    
    // MARK: - Action
    public func roll() -> RollResult {
        if isMarked == false {
            var result: Stick.RollResult
            repeat {
                 result = RollResult.allCases.randomElement()!
            } while result == .frontMarked
            return result
        } else {
            return RollResult.allCases.randomElement()!
        }
    }
}
