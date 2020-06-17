//
//  TokenViewController.swift
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

public class TokenViewController: SceneViewController {
    private lazy var game = Game()
    private var tokenNodes = [SCNNode]()
    
    // MARK: - View life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene?.physicsWorld.gravity = SCNVector3(0, -0.098, 0)
        addLight()
        addCamera()
        addFloor()
        addTokens()
    }
    
    // MARK: - Setup
    private func addTokens() {
        var newNodes: [SCNNode]
        newNodes = (1...20).map { _ in
            let url = URL.usdzURL(for: TokenType.plastic.player1ResourceName)
            let node = SCNReferenceNode(url: url)!
            node.load()
            return node
        }
        tokenNodes.append(contentsOf: newNodes)
        
        newNodes = (1...20).map { _ in
            let url = URL.usdzURL(for: TokenType.plastic.player2ResourceName)
            let node = SCNReferenceNode(url: url)!
            node.load()
            return node
        }
        tokenNodes.append(contentsOf: newNodes)
        
        tokenNodes.forEach { node in
            let randomX = Float.random(in: -0.5...0.5)
            let randomY = Float.random(in: 4...8)
            let randomZ = Float.random(in: -0.5...0.5)
            
            node.position = SCNVector3(randomX, randomY, randomZ)
            node.scale = SCNVector3(4, 4, 4)
            node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: node.presentation.fittingBox(scaled: 4), options: nil))
            scene.rootNode.addChildNode(node)
        }
    }
}
