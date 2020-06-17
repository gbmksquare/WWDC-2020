//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation
import os.log

public class TurnManager {
    private let player1: Player
    private let player2: Player
    
    public var isPlayer1Turn = true
    
    public weak var delegate: TurnManagerDelegate?
    
    public var currentPlayer: Player {
        if isPlayer1Turn {
            return player1
        } else {
            return player2
        }
    }
    
    public var opponentPlayer: Player {
        if isPlayer1Turn {
            return player2
        } else {
            return player1
        }
    }
    
    // MARK: - Initialization
    public init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        os_log(.debug, log: .game, "플레이어 %{PUBLIC}@부터 시작합니다.", player1.name)
    }
    
    // MARK: - Action
    public func switchTurn() {
        isPlayer1Turn = !isPlayer1Turn
        if isPlayer1Turn  {
            os_log(.debug, log: .game, "플레이어 %{PUBLIC}@의 차례입니다.", player1.name)
            delegate?.turnManager(turnManager: self, switchedTurnTo: player1)
        } else {
            os_log(.debug, log: .game, "플레이어 %{PUBLIC}@의 차례입니다.", player2.name)
            delegate?.turnManager(turnManager: self, switchedTurnTo: player2)
        }
    }
}
