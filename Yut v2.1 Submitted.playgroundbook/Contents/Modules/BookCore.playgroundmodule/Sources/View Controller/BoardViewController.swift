//
//  BoardViewController.swift
//  WWDC 2020
//
//  Created by BumMo Koo on 2020/05/18.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import UIKit
import SceneKit
#if canImport(PlaygroundSupport)
import PlaygroundSupport
#endif

public class BoardViewController: SceneViewController {
    private var boardNode: SCNNode!
    
    // MARK: - View life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        addLight()
        addCamera(position: SceneSettings.cameraNodeBoardPosition, eulerAngles: SceneSettings.cameraNodeBoardEulerAngles)
        addFloor()
        addBoard()
    }
    
    // MARK: - Setup
    private func addBoard() {
        let boardURL = URL.boardURL
        let boardNode = SCNReferenceNode(url: boardURL)!
        boardNode.name = SceneSettings.boardNodeName
        boardNode.load()
        sceneView.scene?.rootNode.addChildNode(boardNode)
        boardNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: boardNode.fittingBox))
        self.boardNode = boardNode
    }
}
