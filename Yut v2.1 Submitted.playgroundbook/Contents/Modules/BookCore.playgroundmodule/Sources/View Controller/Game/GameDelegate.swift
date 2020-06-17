//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation

protocol GameDelegate: class {
    func started(game: Game)
    func game(_: Game, switchedTurnTo player: Player)
    func game(_: Game, waitingRollFrom player: Player)
    func game(_: Game, player: Player, canMove steps: [Int], to positions: [BoardPosition])
    func game(_: Game, player: Player, pieces: [Piece], movedTo position: BoardPosition)
    func game(_: Game, eatenPieces: [Piece])
    func game(_: Game, wonBy player: Player)
}
