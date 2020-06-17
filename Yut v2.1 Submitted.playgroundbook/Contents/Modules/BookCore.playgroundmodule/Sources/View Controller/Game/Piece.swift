//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation

public class Piece: Equatable, CustomDebugStringConvertible {
    public let identifier = UUID().uuidString
    public let name: String
    public let player: Player
    public var currentPosition: BoardPosition
    public var history: [BoardPosition]
    
    // MARK: - Initalization
    init(name: String,
         player: Player,
         position: BoardPosition) {
        self.name = name
        self.player = player
        self.currentPosition = position
        history = []
    }
    
    // MARK: - Debug
    public var debugDescription: String {
        return "Piece \(name) of Player \(player.name) at \(currentPosition)"
    }
    
    // MARK: - Equatable
    public static func == (lhs: Piece, rhs: Piece) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
