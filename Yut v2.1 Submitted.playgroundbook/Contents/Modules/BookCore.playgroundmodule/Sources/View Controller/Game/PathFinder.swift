//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation

public final class PathFinder {
    public static let shared = PathFinder()
    
    // MARK: - Action
    public func possibleDestination(from position: BoardPosition,
                                           moving steps: Int,
                                           isStartingPosition: Bool = false) -> [BoardPosition] {
        // No more steps
        if steps == 0 {
            return [position]
        }
        // Already reached end
        if position.type == .end {
            return [position]
        }
        // Moving back
        if steps == -1 {
            if position.type == .start {
                return [position]
            }
            return position.prev
        }
        if (position.type == .branch || position.type == .center) && isStartingPosition == true {
            return position.next.compactMap {
                possibleDestination(from: $0, moving: steps - 1).first
            }
        }
        if let next = position.next.first {
            return possibleDestination(from: next, moving: steps - 1)
        }
        fatalError()
    }
}
