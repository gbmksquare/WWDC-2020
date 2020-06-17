//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation
import os.log

public class Board {
    public let start: BoardPosition
    public let end: BoardPosition
    
    public let p1: BoardPosition
    public let p2: BoardPosition
    public let p3: BoardPosition
    public let p4: BoardPosition
    public let p5: BoardPosition
    public let p6: BoardPosition
    public let p7: BoardPosition
    public let p8: BoardPosition
    public let p9: BoardPosition
    public let p10: BoardPosition
    public let p11: BoardPosition
    public let p12: BoardPosition
    public let p13: BoardPosition
    public let p14: BoardPosition
    public let p15: BoardPosition
    public let p16: BoardPosition
    public let p17: BoardPosition
    public let p18: BoardPosition
    public let p19: BoardPosition
    public let p20: BoardPosition
    
    public let d1_1: BoardPosition
    public let d1_2: BoardPosition
    public let d1_3: BoardPosition
    public let d1_4: BoardPosition
    public let center: BoardPosition
    public let d2_1: BoardPosition
    public let d2_2: BoardPosition
    public let d2_3: BoardPosition
    public let d2_4: BoardPosition
    
    private let allPositions: [BoardPosition]
    
    public let player1Pieces: [Piece]
    public let player2Pieces: [Piece]
    
    public weak var delegate: BoardDelegate?
    
    // MARK: - Initialization
    public init(player1: Player, player2: Player) {
        start = BoardPosition(name: "start", type: .start)
        end = BoardPosition(name: "end", type: .end)

        p1 = BoardPosition(name: "p1", type: .path)
        p2 = BoardPosition(name: "p2", type: .path)
        p3 = BoardPosition(name: "p3", type: .path)
        p4 = BoardPosition(name: "p4", type: .path)
        p5 = BoardPosition(name: "p5", type: .branch)
        p6 = BoardPosition(name: "p6", type: .path)
        p7 = BoardPosition(name: "p7", type: .path)
        p8 = BoardPosition(name: "p8", type: .path)
        p9 = BoardPosition(name: "p9", type: .path)
        p10 = BoardPosition(name: "p10", type: .branch)
        p11 = BoardPosition(name: "p11", type: .path)
        p12 = BoardPosition(name: "p12", type: .path)
        p13 = BoardPosition(name: "p13", type: .path)
        p14 = BoardPosition(name: "p14", type: .path)
        p15 = BoardPosition(name: "p15", type: .branch)
        p16 = BoardPosition(name: "p16", type: .path)
        p17 = BoardPosition(name: "p17", type: .path)
        p18 = BoardPosition(name: "p18", type: .path)
        p19 = BoardPosition(name: "p19", type: .path)
        p20 = BoardPosition(name: "p20", type: .path)
        d1_1 = BoardPosition(name: "d1_1", type: .path)
        d1_2 = BoardPosition(name: "d1_2", type: .path)
        d1_3 = BoardPosition(name: "d1_3", type: .path)
        d1_4 = BoardPosition(name: "d1_4", type: .path)
        center = BoardPosition(name: "center", type: .center)
        d2_1 = BoardPosition(name: "d2_1", type: .path)
        d2_2 = BoardPosition(name: "d2_2", type: .path)
        d2_3 = BoardPosition(name: "d2_3", type: .path)
        d2_4 = BoardPosition(name: "d2_4", type: .path)
        
        allPositions = [start, end, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, d1_1, d1_2, d1_3, d1_4, center, d2_1, d2_2, d2_3, d2_4]
        
        start.prev = [start]
        end.prev = [end]
        p1.prev = [p20]
        p2.prev = [p1]
        p3.prev = [p2]
        p4.prev = [p3]
        p5.prev = [p4]
        p6.prev = [p5]
        p7.prev = [p6]
        p8.prev = [p7]
        p9.prev = [p8]
        p10.prev = [p9]
        p11.prev = [p10]
        p12.prev = [p11]
        p13.prev = [p12]
        p14.prev = [p13]
        p15.prev = [p14, d1_4]
        p16.prev = [p15]
        p17.prev = [p16]
        p18.prev = [p17]
        p19.prev = [p18]
        p20.prev = [p19, d2_4]

        d1_1.prev = [p5]
        d1_2.prev = [d1_1]
        d1_3.prev = [center]
        d1_4.prev = [d1_3]
        center.prev = [d1_2, d2_2]
        d2_1.prev = [p10]
        d2_2.prev = [d2_1]
        d2_3.prev = [center]
        d2_4.prev = [d2_3]

        start.next = [p1]
        end.next = [end]
        p1.next = [p2]
        p2.next = [p3]
        p3.next = [p4]
        p4.next = [p5]
        p5.next = [p6, d1_1]
        p6.next = [p7]
        p7.next = [p8]
        p8.next = [p9]
        p9.next = [p10]
        p10.next = [p11, d2_1]
        p11.next = [p12]
        p12.next = [p13]
        p13.next = [p14]
        p14.next = [p15]
        p15.next = [p16]
        p16.next = [p17]
        p17.next = [p18]
        p18.next = [p19]
        p19.next = [p20]
        p20.next = [end]

        d1_1.next = [d1_2]
        d1_2.next = [center]
        d1_3.next = [d1_4]
        d1_4.next = [p15]
        center.next = [d1_3, d2_3]
        d2_1.next = [d2_2]
        d2_2.next = [center]
        d2_3.next = [d2_4]
        d2_4.next = [p20]
        
        player1Pieces = [
            Piece(name: "1", player: player1, position: start),
            Piece(name: "2", player: player1, position: start),
            Piece(name: "3", player: player1, position: start),
            Piece(name: "4", player: player1, position: start)
        ]
        player2Pieces = [
            Piece(name: "1", player: player2, position: start),
            Piece(name: "2", player: player2, position: start),
            Piece(name: "3", player: player2, position: start),
            Piece(name: "4", player: player2, position: start)
        ]
        
        player1.pieces = player1Pieces
        player2.pieces = player2Pieces
        player1.activePiece = player1Pieces.first
        player2.activePiece = player2Pieces.first
        
        start.pieces = player1Pieces + player2Pieces
    }
    
    // MARK: - Variable
    public func pieces(for player: Player) -> [Piece] {
        if player.name == "1" {
            return player1Pieces
        } else {
            return player2Pieces
        }
    }
    
    public func token(withIdentifier identifier: String) -> Piece? {
        let allTokens = player1Pieces + player2Pieces
        return allTokens.first { $0.identifier == identifier }
    }
    
    public func position(withIdentifier identifier: String) -> BoardPosition? {
        return allPositions.first { $0.identifier == identifier }
    }
    
    public func position(withName name: String) -> BoardPosition? {
        return allPositions.first { $0.name == name }
    }
    
    // MARK: - Action
    public func move(piece: Piece, to position: BoardPosition, player: Player) -> Bool {
        let pieces: [Piece]
        let previousPosition = piece.currentPosition
        if previousPosition != start {
            pieces = previousPosition.pieces
            previousPosition.pieces.removeAll(where: { $0 == piece })
        } else {
            pieces = [piece]
        }
        os_log(.debug, log: .game, "%{PUBLIC}@에서 이동합니다.", previousPosition.debugDescription)
        previousPosition.pieces = []
        
        if position.pieces.count == 0 {
            os_log(.debug, log: .game, "%{PUBLIC}@이 비어있습니다.", position.debugDescription)
            position.pieces = pieces
            pieces.forEach {
                $0.currentPosition = position
            }
            delegate?.board(self, moved: pieces, to: position)
        } else if position.pieces.count > 0 {
            os_log(.debug, log: .game, "%{PUBLIC}@에 %{PUBLIC}@ 말이 있습니다.", position.debugDescription, position.pieces.debugDescription)
            if position != start {
                // Same player - group
                if piece.player == position.pieces.first!.player {
                    os_log(.debug, log: .game, "새로운 말이 기존 말을 업습니다.")
                    position.pieces.append(contentsOf: pieces)
                    pieces.forEach {
                        $0.currentPosition = position
                    }
                    delegate?.board(self, moved: pieces, to: position)
                } else {
                    os_log(.debug, log: .game, "%{PUBLIC}@은 잡혀서 시작 지점으로 이동합니다.", position.pieces.debugDescription)
                    delegate?.board(self, pieceEaten: position.pieces)
                    position.pieces.forEach {
                        $0.currentPosition = start
                    }
                    start.pieces.append(contentsOf: position.pieces)
                    delegate?.board(self, moved: position.pieces, to: start)
                    
                    position.pieces = pieces
                    pieces.forEach {
                        $0.currentPosition = position
                    }
                    delegate?.board(self, moved: pieces, to: position)
                    return true
                }
            } else {
                piece.currentPosition = start
                start.pieces.append(piece)
                delegate?.board(self, moved: [piece], to: start)
            }
        }
        return false
    }
}
