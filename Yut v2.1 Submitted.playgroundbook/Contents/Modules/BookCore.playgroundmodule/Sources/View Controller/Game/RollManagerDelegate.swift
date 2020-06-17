//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation

public protocol RollManagerDelegate: class {
    func rollManager(rollManager: RollManager, rolledToGo steps: [Int])
}
