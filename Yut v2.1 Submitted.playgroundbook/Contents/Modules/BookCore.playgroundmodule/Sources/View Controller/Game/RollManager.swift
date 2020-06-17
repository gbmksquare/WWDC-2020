//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import Foundation
import os.log

public class RollManager {
    private let sticks: StickSet
    
    private lazy var availableSteps = [Int]()
    
    public weak var delegate: RollManagerDelegate?
    
    // MARK: - Initalization
    init() {
        sticks = StickSet()
    }
    
    // MARK: - Action (Old)
    @available(*, deprecated)
    func rollForCurrentTurn(_ clearPreviousSteps: Bool = true) -> [Int] {
        if clearPreviousSteps {
            availableSteps = []
        }
        
        let (setResult, _) = sticks.roll()
        availableSteps.append(setResult.steps)
        if setResult.canRollOneMoreTime {
            _ = rollForCurrentTurn(false)
        }
        os_log(.debug, log: .game, "획득한 칸수는 %{PUBLIC}@", availableSteps.debugDescription)
        delegate?.rollManager(rollManager: self, rolledToGo: availableSteps)
        return availableSteps
    }
    
    @available(*, deprecated)
    func recieveRollResult(_ result: [Stick.RollResult], clearPreviousSteps: Bool = true) {
        if clearPreviousSteps {
            availableSteps = []
        }
        
        let setResult = StickSet.getSetResult(from: result)
        availableSteps.append(setResult.steps)
        if setResult.canRollOneMoreTime {
            // ROll one more time
        }
        os_log(.debug, log: .game, "획득한 칸수는 %{PUBLIC}@", availableSteps.debugDescription)
        delegate?.rollManager(rollManager: self, rolledToGo: availableSteps)
//        return availableSteps
    }
    
    // MARK: - Action
    func roll() -> (StickSet.RollResult, [Stick.RollResult]) {
        let results = sticks.roll()
        _ = receive(result: results.0)
        return results
    }
    
    func receive(result: StickSet.RollResult) -> Bool {
        availableSteps.append(result.steps)
        os_log(.debug, log: .game, "던진 결과는 \"%{PUBLIC}@\"", result.debugDescription)
        if result.canRollOneMoreTime {
            os_log(.debug, log: .game, "한 번 더 던질 수 있습니다.")
        }
        os_log(.debug, log: .game, "총 전진 가능한 칸수는 %{PUBLIC}@", availableSteps.debugDescription)
        return result.canRollOneMoreTime
    }
    
    func popAvailableSteps() -> [Int] {
        let steps = availableSteps
        availableSteps = []
        return steps
    }
    
    private func clearSteps() {
        availableSteps = []
    }
}
