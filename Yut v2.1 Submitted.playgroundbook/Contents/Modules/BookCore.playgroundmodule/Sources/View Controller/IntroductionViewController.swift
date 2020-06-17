//
//  IntroductionViewController.swift
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

public class IntroductionViewController: SceneViewController {
    private var titleTextNode: SCNNode!
    private var subtitleTextNode: SCNNode!
    private var boardNode: SCNNode!
    private var stickNodes = [SCNNode]()
    
    // MARK: - View life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        SCNTransaction.animationDuration = 0
        addLight()
        addCamera(position: SCNVector3(0, 3, 5), eulerAngles: SCNVector3(0, 0, 0))
        addFloor()
        addText()
        addBoard()
        addSticks()
        throwSticks()
    }
    
    // MARK: - Setup
    private func addText() {
        let titleMaterial = SCNMaterial()
        titleMaterial.diffuse.contents = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        titleMaterial.metalness.contents = 0.15
        titleMaterial.reflective.contents = 0
        
        let subtitleMaterial = SCNMaterial()
        subtitleMaterial.diffuse.contents = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        subtitleMaterial.metalness.contents = 0.15
        subtitleMaterial.reflective.contents = 0
        
        let titleText = SCNText(string: "Yut", extrusionDepth: 3)
        titleText.firstMaterial = titleMaterial
        
        let subtitleText = SCNText(string: "a Game", extrusionDepth: 1.5)
        subtitleText.firstMaterial = subtitleMaterial
        
        let titleTextNode = SCNNode(geometry: titleText)
        sceneView.scene?.rootNode.addChildNode(titleTextNode)
        titleTextNode.position = SCNVector3(-8, -2, -20)
        titleTextNode.scale = SCNVector3(0.85, 0.85, 0.85)
        titleTextNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        self.titleTextNode = titleTextNode
        
        let subtitleTextNode = SCNNode(geometry: subtitleText)
        sceneView.scene?.rootNode.addChildNode(subtitleTextNode)
        subtitleTextNode.position = SCNVector3(-2, 0, -17)
        subtitleTextNode.scale = SCNVector3(0.2, 0.2, 0.2)
        subtitleTextNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        self.titleTextNode = titleTextNode
    }
    
    private func addBoard() {
        let boardURL = URL.boardURL
        let boardNode = SCNReferenceNode(url: boardURL)!
        boardNode.name = SceneSettings.boardNodeName
        boardNode.load()
        boardNode.position = SCNVector3(-3, 0, -6)
        boardNode.eulerAngles = SCNVector3(0, -Double.pi/4, 0)
        boardNode.scale = SCNVector3(3, 3, 3)
        sceneView.scene?.rootNode.addChildNode(boardNode)
        boardNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: boardNode.fittingBox))
        self.boardNode = boardNode
    }
    
    private func addSticks() {
        let stickURL = URL.stickURL
        stickNodes = (1...20).map { index in
            let stickNode = SCNReferenceNode(url: stickURL)!
            stickNode.name = SceneSettings.stickNodeName + "\(index)"
            
            let randomX = Float.random(in: -2...2)
            let randomZ = Float.random(in: -10...0)
            
            stickNode.position = SCNVector3(randomX, 0, randomZ)
            stickNode.load()
            stickNode.scale = SCNVector3(3, 3, 3)
            scene.rootNode.addChildNode(stickNode)
            return stickNode
        }

        stickNodes.forEach { node in
            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            node.physicsBody = physicsBody
        }
    }
    
    // MARK: - Action
    private func throwSticks() {
        stickNodes.forEach { stick in
            let randomX = Float.random(in: -2...2)
            let randomY = Float.random(in: 3...10)
            let force = SCNVector3(x: randomX, y: randomY , z: 0)
            let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
            stick.physicsBody?.applyForce(force, at: position, asImpulse: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.throwSticks()
        }
    }
}
