//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation

public class BoardPosition: Equatable, CustomDebugStringConvertible {
    public enum PositionType: String, CustomDebugStringConvertible {
        case start
        case end
        case path
        case branch
        case center
        
        // MARK: - Debug
        public var debugDescription: String {
            return rawValue.capitalized
        }
    }
    
    public let identifier = UUID().uuidString
    public let name: String
    public let type: BoardPosition.PositionType
    
    public var next = [BoardPosition]()
    public var prev = [BoardPosition]()
    
    public var pieces = [Piece]()
    
    // MARK: - Initalization
    public init(name: String, type: BoardPosition.PositionType) {
        self.name = name
        self.type = type
    }
    
    // MARK: - Debug
    public var debugDescription: String {
        return name
    }
    
    // MARK: - Equatable
    public static func == (lhs: BoardPosition, rhs: BoardPosition) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
