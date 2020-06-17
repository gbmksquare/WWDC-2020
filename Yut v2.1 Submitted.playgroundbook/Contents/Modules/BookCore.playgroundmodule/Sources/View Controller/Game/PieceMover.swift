//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation
import os.log

class PieceMover {
    private let board: Board
    private let player1: Player
    private let player2: Player
    
    public private(set) var remainingSteps = [Int]()
    private var register = [(Int, [BoardPosition])]()
    
    public weak var game: Game?
    
    // MARK: - Initialization
    public init(board: Board, player1: Player, player2: Player) {
        self.board = board
        self.player1 = player1
        self.player2 = player2
    }
    
    // MARK: - Action
    func move(steps: [Int], for player: Player) -> (Bool, Bool) {
        os_log(.debug, log: .game, "플레이어 %{PUBLIC}@는 %{PUBLIC}@만큼 전진할 수 있습니다.", player.name, steps.debugDescription)
        var canRollOneMoreTime = false
        for step in steps {
            let piece = board.pieces(for: player).first!
            let destination = PathFinder.shared.possibleDestination(from: piece.currentPosition, moving: step)
            os_log(.debug, log: .game, "%{PUBLIC}@ 말은 %{PUBLIC}@으로 이동할 수 있습니다.", piece.debugDescription, destination.debugDescription)
            if destination.count == 1 {
                canRollOneMoreTime = board.move(piece: piece, to: destination.first!, player: player)
            } else {
                canRollOneMoreTime = board.move(piece: piece, to: destination.last!, player: player)
            }
            os_log(.debug, log: .game, "%{PUBLIC}@ 말은 %{PUBLIC}@으로 이동합니다.", piece.debugDescription, destination.debugDescription)
            if canRollOneMoreTime {
                os_log(.debug, log: .game, "상대방의 말을 잡아 한 번 더 기회가 주어집니다.")
            }
            
            if destination.first!.type == .end {
                os_log(.debug, log: .game, "%{PUBLIC}@ 말이 종점에 도착했습니다!", piece.debugDescription)
                return (canRollOneMoreTime, true)
            }
        }
        return (canRollOneMoreTime, false)
    }
    
    // MARK: - Action
    func registerMovableSteps(steps: [Int]) {
        remainingSteps = steps
    }
    
    func possibleDestinations(for piece: Piece) -> [BoardPosition] {
        register = remainingSteps.map {
            ($0, PathFinder.shared.possibleDestination(from: piece.currentPosition, moving: $0, isStartingPosition: true))
        }
        return register.flatMap { $1 }
    }
    
    func move(piece: Piece, to position: BoardPosition) -> Bool {
        let canRollOneMoreTime = board.move(piece: piece, to: position, player: piece.player)
        
        if let index = register.firstIndex(where: { $0.1.contains(position) }) {
            remainingSteps.remove(at: index)
            register.removeAll()
        }
        if canRollOneMoreTime, let game = game {
            game.delegate?.game(game, waitingRollFrom: game.turnManager.currentPlayer)
            return true
        }
        if remainingSteps.count > 0 {
            return true
        } else {
            return false
        }
    }
}
