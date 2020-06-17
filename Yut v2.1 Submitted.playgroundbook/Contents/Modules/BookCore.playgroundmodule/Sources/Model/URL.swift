//
//  URL.swift
//  WWDC 2020
//
//  Created by BumMo Koo on 2020/05/18.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation

public extension URL {
    static let boardURL = Bundle.main.url(forResource: "Board", withExtension: "usdz")!
    static let stickURL = Bundle.main.url(forResource: "Stick", withExtension: "usdz")!
    
    static func usdzURL(for name: String) -> URL {
        return Bundle.main.url(forResource: name, withExtension: "usdz")!
    }
}

