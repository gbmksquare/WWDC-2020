//
//  StickViewController.swift
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

public class StickViewController: SceneViewController {
    @IBOutlet public var controlView: UIView!
    @IBOutlet public var resultLabel: UILabel!
    @IBOutlet public var descriptionLabel: UILabel!
    @IBOutlet public var throwButton: UIButton!
    
    private var waitingForRollResult = false {
        didSet {
            if waitingForRollResult {
                throwButton.isEnabled = false
            } else {
                throwButton.isEnabled = true
            }
        }
    }
    
    private var stickNodes = [SCNNode]()
    
    // MARK: - View life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        controlView.layer.cornerRadius = 9
        sceneView.scene?.physicsWorld.gravity = SCNVector3(0, -0.98, 0)
        sceneView.delegate = self
        addLight()
        addCamera(position: SceneSettings.cameraNodeBoardPosition, eulerAngles: SceneSettings.cameraNodeBoardEulerAngles)
        addFloor()
        addSticks()
    }
    
    // MARK: - Setup
    private func addSticks() {
        let stickURL = URL.stickURL
        stickNodes = (1...4).map { index in
            let stickNode = SCNReferenceNode(url: stickURL)!
            stickNode.name = SceneSettings.stickNodeName + "\(index)"
            
            let randomX = Float.random(in: -0.5...0.5)
            let randomY = Float.random(in: 4...8)
            let randomZ = Float.random(in: -0.5...0.5)
            
            stickNode.position = SCNVector3(randomX, randomY, randomZ)
            stickNode.load()
            stickNode.physicsBody?.mass = 1
            scene.rootNode.addChildNode(stickNode)
            return stickNode
        }

        stickNodes.forEach { node in
            // Custom Geometry
            let radius: CGFloat = 0.157 / 2
            let length: CGFloat = 1.34
            let coordinate: CGFloat = sqrt(2) * radius / 2
            let vertices: [SCNVector3] = [
                // Front
                SCNVector3(-radius,     0,          length/2),
                SCNVector3(-coordinate, coordinate, length/2),
                SCNVector3(coordinate,  coordinate, length/2),
                SCNVector3(radius,      0,          length/2),
                
                // Back
                SCNVector3(-radius,     0,          -length/2),
                SCNVector3(-coordinate, coordinate, -length/2),
                SCNVector3(coordinate,  coordinate, -length/2),
                SCNVector3(radius,      0,          -length/2),
            ]
            let indices: [UInt16] = [
                // Front
                0,2,1,
                0,3,2,
                
                // Back
                5,6,4,
                4,6,7,
                
                // Bottom
                0,4,3,
                3,4,7,
                
                // Top
                1,6,5,
                1,2,6,
                
                // Side
                3,6,2,
                3,7,6,
                0,1,5,
                0,5,4
            ]
            // TODO: Move custom geometry

            let source = SCNGeometrySource(vertices: vertices)
            let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
            let geometry = SCNGeometry(sources: [source], elements: [element])

            let physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry))
            node.physicsBody = physicsBody
        }
    }
    
    // MARK: - User interaction
    @IBAction
    private func tap(throw button: UIButton) {
        throwSticks()
    }
    
    // MARK: - Motion
    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake  else {
            return
        }
        throwSticks()
    }
    
    // MARK: - Action
    private func throwSticks() {
        waitingForRollResult = true
        stickNodes.forEach { node in
            let upward = SCNVector3(0, 1.25, 0)
            let at = SceneSettings.stickThrowAt
            node.physicsBody?.applyForce(upward, at: at, asImpulse: true)
        }
    }
    
    private func checkRollResult() {
        if waitingForRollResult == false {
            return
        }
        let isResting = (1...4).compactMap { index in
            return sceneView.scene?.rootNode.childNode(withName: "stick_\(index)", recursively: true)?.physicsBody?.isResting
        }
        guard isResting.contains(false) == false else {
            return
        }
        let results: [Stick.RollResult] = (1...4).compactMap { index in
            let stickNodes = sceneView.scene?.rootNode.childNode(withName: "stick_\(index)", recursively: true)
            if stickNodes!.presentation.worldUp.y > 0 {
                // Back (Ridge)
                return Stick.RollResult.back
            } else {
                // Front (Flat)
                return Stick.RollResult.front
            }
        }
        let result = StickSet.getSetResult(from: results)
        switch result {
            case .do:
            resultLabel.text = "\(result.name)! 🐖"
            descriptionLabel.text = "You can advance \(result.steps) steps."
            case .gae:
            resultLabel.text = "\(result.name)! 🐕"
            descriptionLabel.text = "You can advance \(result.steps) steps."
            case .gir:
            resultLabel.text = "\(result.name)! 🐑"
            descriptionLabel.text = "You can advance \(result.steps) steps."
            case .yut:
            resultLabel.text = "\(result.name)! 🐂"
            descriptionLabel.text = "You can advance \(result.steps) steps."
            case .mo:
            resultLabel.text = "\(result.name)! 🐎"
            descriptionLabel.text = "You can advance \(result.steps) steps."
            default:
            resultLabel.text = "--"
            descriptionLabel.text = "--"
        }
        waitingForRollResult = false
    }
}

// MARK - Scene
extension StickViewController: SCNSceneRendererDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.checkRollResult()
        }
    }
}

