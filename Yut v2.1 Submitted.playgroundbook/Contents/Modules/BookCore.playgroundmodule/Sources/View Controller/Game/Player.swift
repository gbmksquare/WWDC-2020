//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation

public class Player: Equatable {
    public let identifier = UUID().uuidString
    public let name: String
    
    public var pieces = [Piece]()
    public var activePiece: Piece?
    
    // MARK: - Initiazliation
    public init(name: String) {
        self.name = name
    }
    
    // MARK: - Equatable
    public static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
