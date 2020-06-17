//
//  SceneSettings.swift
//  WWDC 2020
//
//  Created by BumMo Koo on 2020/05/18.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import SceneKit

enum SceneSettings {
    static let pointLightNodePosition = SCNVector3(0, 10, 10)
    
    static let cameraZNear: Double = 0
    static let cameraZFar: Double = 50
    
    static let cameraNodePosition = SCNVector3(0, 2.5, -2.5)
    static let cameraNodeEulerAngles = SCNVector3(-Double.pi/3.5, Double.pi, 0)
    
    static let cameraNodeBoardPosition = SCNVector3(0, 4, -2.5)
    static let cameraNodeBoardEulerAngles = SCNVector3(-Double.pi/3, Double.pi, 0)
    
    static let startNodePosition = SCNVector3(0, 0, -2)
    static let endNodePosition = SCNVector3(0, 0, 2)
    
    static let boardNodeName = "board"
    static let stickNodeName = "stick_"
    static let tokenNodeName = "token_"
    static let helpStationNodeName = "help_"
    
    static let stickThrowForce = SCNVector3(0, 1.25, 0)
    static let stickThrowAt = SCNVector3(0, 0, 0.5)
    
    static let animationDuration: CFTimeInterval = 1
}
