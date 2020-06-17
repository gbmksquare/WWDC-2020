//
//  SceneViewController.swift
//  WWDC 2020
//
//  Created by BumMo Koo on 2020/05/18.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import UIKit
import SceneKit

public class SceneViewController: UIViewController {
    @IBOutlet var sceneView: SCNView!
    var scene: SCNScene {
        return sceneView.scene!
    }
    
    var cameraNode: SCNNode!
    
    // MARK: - View life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        // MARK: Scene
        let scene = SCNScene(named: "Game.scnassets/Empty.scn")!
        sceneView.scene = scene
        SCNTransaction.animationDuration = SceneSettings.animationDuration
    }
    
    func addLight() {
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor.darkGray
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        sceneView.scene?.rootNode.addChildNode(ambientLightNode)
        
        let pointLight = SCNLight()
        pointLight.type = .omni
        let pointLightNode = SCNNode()
        pointLightNode.light = pointLight
        pointLightNode.position = SceneSettings.pointLightNodePosition
        sceneView.scene?.rootNode.addChildNode(pointLightNode)
    }
    
    func addCamera(position: SCNVector3 = SceneSettings.cameraNodePosition, eulerAngles: SCNVector3 = SceneSettings.cameraNodeEulerAngles) {
        let camera = SCNCamera()
        camera.zNear = SceneSettings.cameraZNear
        camera.zFar = SceneSettings.cameraZFar
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = position
        cameraNode.eulerAngles = eulerAngles
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        
        self.cameraNode = cameraNode
    }
    
    func addFloor() {
        let floor = SCNFloor()
        floor.reflectivity = 0
        floor.firstMaterial = SCNMaterial.floorMaterial
        let floorNode = SCNNode(geometry: floor)
        sceneView.scene?.rootNode.addChildNode(floorNode)
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
    }
}
