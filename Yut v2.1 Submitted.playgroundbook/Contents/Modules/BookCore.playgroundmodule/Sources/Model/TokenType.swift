//
//  TokenType.swift
//  WWDC 2020
//
//  Created by BumMo Koo on 2020/05/18.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation

public enum TokenType {
    case plastic
    
    public var player1ResourceName: String {
        switch self {
            case .plastic: return "Token_Plastic_red"
        }
    }
    
    public var player2ResourceName: String {
        switch self {
            case .plastic: return "Token_Plastic_blue"
        }
    }
}
