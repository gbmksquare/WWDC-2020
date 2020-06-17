//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation
import os.log

class Game {
    let board: Board
    let player1: Player
    let player2: Player
    
    let sticks: StickSet
    
    weak var delegate: GameDelegate?
    
     var turnManager: TurnManager
    private var rollManager: RollManager
     var pieceMover: PieceMover
    
    // MARK: - Initliazation
    init() {
        player1 = Player(name: "1")
        player2 = Player(name: "2")
        board = Board(player1: player1, player2: player2)
        
        sticks = StickSet()
        
        turnManager = TurnManager(player1: player1, player2: player2)
        rollManager = RollManager()
        pieceMover = PieceMover(board: board, player1: player1, player2: player2)
        board.delegate = self
        turnManager.delegate = self
        rollManager.delegate = self
        pieceMover.game = self
    }
    
    // MARK: - Game
    func startGame() {
        DispatchQueue.main.async {
            self.delegate?.started(game: self)
            self.delegate?.game(self, switchedTurnTo: self.player1)
            self.delegate?.game(self, waitingRollFrom: self.player1)
        }
    }
    
    func simulateGame() {
        os_log(.debug, log: .game, "플레이어 1과 플레이어 2의 게임을 시작합니다.")
        
        func run() {
            let availableSteps = rollManager.rollForCurrentTurn()
            let player = turnManager.currentPlayer
            let (canRollOneMoreTime, gameEnded) = pieceMover.move(steps: availableSteps, for: player)
            if gameEnded {
                os_log(.debug, log: .game, "게임이 종료되었습니다. 플레이어 %{PUBLIC}@가 승리했습니다!", player.name)
            } else {
                if canRollOneMoreTime {
                    
                } else {
                    turnManager.switchTurn()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    run()
                }
            }
            os_log(.debug, log: .game, "\n", player1.name)
        }
        
        run()
    }
    
    private func endGame() {
        DispatchQueue.main.async {
            self.delegate?.game(self, wonBy: self.player1)
        }
    }
    
    // MARK: - Roll
    func receive(rollResult: StickSet.RollResult) {
        let player = turnManager.currentPlayer
        let canRollOneMoreTime = rollManager.receive(result: rollResult)
        if canRollOneMoreTime {
            DispatchQueue.main.async {
                self.delegate?.game(self, waitingRollFrom: player)
            }
            return
        }
        let steps = rollManager.popAvailableSteps()
        pieceMover.registerMovableSteps(steps: steps)
        let destinations = pieceMover.possibleDestinations(for: player.activePiece!)
        DispatchQueue.main.async {
            self.delegate?.game(self, player: player, canMove: steps, to: destinations)
        }
    }
    
    // MARK: - Move
    func selectToken(_ token: Piece) {
        token.player.activePiece = token
        let player = turnManager.currentPlayer
        let steps = pieceMover.remainingSteps
        if player == token.player, steps.count > 0 {
            let destinations = pieceMover.possibleDestinations(for: player.activePiece!)
            DispatchQueue.main.async {
                self.delegate?.game(self, player: player, canMove: steps, to: destinations)
            }
        }
    }
    
    func moveCurrentPlayerActiveToken(to position: BoardPosition) {
        let player = turnManager.currentPlayer
        let token = player.activePiece!
        
        let didEnd = player.pieces.map {
            $0.currentPosition.name == "end"
        }
        if !didEnd.contains(false) {
            delegate?.game(self, wonBy: player)
            return
        }
        
        let hasRemainingSteps = pieceMover.move(piece: token, to: position)
        if hasRemainingSteps {
            let destinations = pieceMover.possibleDestinations(for: token)
            DispatchQueue.main.async {
                self.delegate?.game(self, player: player, canMove: self.pieceMover.remainingSteps, to: destinations)
            }
        } else {
            turnManager.switchTurn()
        }
    }
}

// MARK: - Delegate
extension Game: BoardDelegate, TurnManagerDelegate, RollManagerDelegate {
    // MARK: - Board delegate
    func board(_: Board, moved pieces: [Piece], to position: BoardPosition) {
        DispatchQueue.main.async {
            self.delegate?.game(self, player: pieces.first!.player, pieces: pieces, movedTo: position)
        }
    }
    
    func board(_: Board, pieceEaten: [Piece]) {
        DispatchQueue.main.async {
            self.delegate?.game(self, eatenPieces: pieceEaten)
        }
    }
    
    // MARK: Turn manager delegate
    func turnManager(turnManager: TurnManager, switchedTurnTo player: Player) {
        DispatchQueue.main.async {
            self.delegate?.game(self, switchedTurnTo: player)
        }
    }
    
    // MARK: Roll manager delegate
    func rollManager(rollManager: RollManager, rolledToGo steps: [Int]) {
//        delegate?.game(self, canGoForward: steps)
    }
}
