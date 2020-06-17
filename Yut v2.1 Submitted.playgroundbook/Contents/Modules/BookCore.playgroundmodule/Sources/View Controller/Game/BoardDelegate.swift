//
//  BoardDelegate.swift
//  WWDC 2020
//
//  Created by BumMo Koo on 2020/05/18.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation

public protocol BoardDelegate: class {
    func board(_: Board, moved pieces: [Piece], to position: BoardPosition)
    func board(_: Board, pieceEaten: [Piece])
}
