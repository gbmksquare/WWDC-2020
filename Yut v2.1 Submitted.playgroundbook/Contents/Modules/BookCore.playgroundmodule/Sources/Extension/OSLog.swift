//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation
import os.log

public extension OSLog {
    // MARK: - Log
    static var app: OSLog {
        return log(category: "application")
    }
    
    static var sceneKit: OSLog {
        return log(category: "sceneKit")
    }
    
    static var game: OSLog {
        return log(category: "game")
    }
    
    // MARK: - Helper
    private static func log(category: String) -> OSLog {
        let identifier = Bundle.main.bundleIdentifier ?? "com.gbmksquare.WWDC2020"
        return OSLog(subsystem: identifier, category: category)
    }
}
