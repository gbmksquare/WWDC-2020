//
//  SceneKitGameViewController.swift
//  WWDC 2020
//
//  Created by BumMo Koo on 2020/05/18.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import UIKit
import SceneKit
import os.log
#if canImport(PlaygroundSupport)
import PlaygroundSupport
#endif

public class SceneKitGameViewController: UIViewController {
    @IBOutlet private weak var sceneView: SCNView!
    private var scene: SCNScene {
        return sceneView.scene!
    }
    
    @IBOutlet public var controlView: UIView!
    @IBOutlet private weak var throwButton: UIButton!
    
    @IBOutlet private weak var turnLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Node
    private var cameraNode: SCNNode!
    private var boardNode: SCNNode!
    private var stickNodes = [SCNNode]()
    private var tokenNodes = [SCNNode]()
    
    private var startNode: SCNNode!
    private var endNode: SCNNode!
    
    private var helpNodes = [SCNNode]()
    
    private lazy var game = Game()
    private var waitingForRollResult = false {
        didSet {
            if waitingForRollResult {
                throwButton.isEnabled = false
            } else {
                throwButton.isEnabled = true
            }
        }
    }
    
    // MARK: - View life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        game.startGame()
    }
    
    // MARK: - Setup
    private func setup() {
        game.delegate = self
        
        // MARK: Scene
        controlView.layer.cornerRadius = 9
        
        let scene = SCNScene(named: "Game.scnassets/Empty.scn", inDirectory: nil, options: [.convertUnitsToMeters: 1])!
        sceneView.scene = scene
        sceneView.backgroundColor = .black
//        sceneView.allowsCameraControl = true
//        sceneView.showsStatistics = true
        sceneView.delegate = self
        //        sceneView.debugOptions = .showPhysicsShapes
        SCNTransaction.animationDuration = SceneSettings.animationDuration
        
        addLight()
        addCamera()
        addFloor()
        
        addBoard()
        addStartAndEnd()
        addSticks()
        addTokens()
        
        // MARK: - Else initialization
        turnLabel.text = "Player 1's"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    private func addLight() {
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
    
    private func addCamera() {
        let camera = SCNCamera()
        camera.zNear = SceneSettings.cameraZNear
        camera.zFar = SceneSettings.cameraZFar
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SceneSettings.cameraNodeBoardPosition
        cameraNode.eulerAngles = SceneSettings.cameraNodeBoardEulerAngles
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        
        self.cameraNode = cameraNode
    }
    
    private func addFloor() {
        let floor = SCNFloor()
        floor.reflectivity = 0
        floor.firstMaterial = SCNMaterial.floorMaterial
        let floorNode = SCNNode(geometry: floor)
        sceneView.scene?.rootNode.addChildNode(floorNode)
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
    }
    
    private func addBoard() {
        let boardURL = URL.boardURL
        let boardNode = SCNReferenceNode(url: boardURL)!
        boardNode.name = SceneSettings.boardNodeName
        boardNode.load()
        sceneView.scene?.rootNode.addChildNode(boardNode)
        boardNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: boardNode.fittingBox))
        
        self.boardNode = boardNode
    }
    
    private func addStartAndEnd() {
        let startNode = SCNNode()
        startNode.name = game.board.start.name
        startNode.position = SceneSettings.startNodePosition
        scene.rootNode.addChildNode(startNode)
        self.startNode = startNode
        
        let endNode = SCNNode()
        endNode.name = game.board.end.name
        endNode.position = SceneSettings.endNodePosition
        scene.rootNode.addChildNode(endNode)
        self.endNode = endNode
    }
    
    private func addSticks() {
        let stickURL = URL.stickURL
        stickNodes = (1...4).map { index in
            let stickNode = SCNReferenceNode(url: stickURL)!
            stickNode.name = SceneSettings.stickNodeName + "\(index)"
            stickNode.position = SCNVector3(Double(index) - 1, 2.5, 0)
            stickNode.load()
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
    
    private func addTokens() {
        let player1TokenNodes: [SCNNode] = game.board.player1Pieces.enumerated().map { (index, token) in
            let url = URL.usdzURL(for: TokenType.plastic.player1ResourceName)
            let node = SCNReferenceNode(url: url)!
            node.name = SceneSettings.tokenNodeName + token.identifier
            node.load()
            let sp = startNode.position
            let position = SCNVector3(sp.x + Float(index) * 0.25, sp.y, sp.z)
            node.position = position
            scene.rootNode.addChildNode(node)
            return node
        }
        let player2TokenNodes: [SCNNode] = game.board.player2Pieces.enumerated().map { (index, token) in
            let url = URL.usdzURL(for: TokenType.plastic.player2ResourceName)
            let node = SCNReferenceNode(url: url)!
            node.name = SceneSettings.tokenNodeName + token.identifier
            node.load()
            let sp = startNode.position
            let position = SCNVector3(sp.x + Float(index) * 0.25, sp.y, sp.z + 0.25)
            node.position = position
            scene.rootNode.addChildNode(node)
            return node
        }
        tokenNodes = player1TokenNodes + player2TokenNodes
    }
    
    // MARK: - User interaction
    @IBAction
    private func tap(roll button: UIButton) {
        rollSticks()
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        let location = gestureRecognize.location(in: sceneView)
        let hits = sceneView.hitTest(location, options: nil)
        guard let tappedNode = hits.first?.node else {
            return
        }
        // Token
        if tappedNode.name?.contains("Piece") == true {
            let selectedNode = tappedNode.parent!.parent!.parent
            let tokenIdentifier = selectedNode!.name!.replacingOccurrences(of: SceneSettings.tokenNodeName, with: "")
            guard let token = game.board.token(withIdentifier: tokenIdentifier) else {
                return
            }
            helpNodes.forEach {
                $0.removeFromParentNode()
            }
            helpNodes.removeAll()
            game.selectToken(token)
        }
        // Station
        if tappedNode.name?.contains(SceneSettings.helpStationNodeName) == true {
            let stationName = tappedNode.name!.replacingOccurrences(of: SceneSettings.helpStationNodeName, with: "")
            let station = game.board.position(withName: stationName)
            if let station = station {
                game.moveCurrentPlayerActiveToken(to: station)
            }
            helpNodes.forEach {
                $0.removeFromParentNode()
            }
            helpNodes.removeAll()
            throwButton.isEnabled = true
        }
    }
    
    // MARK: - Motion
    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake  else {
            return
        }
        rollSticks()
    }
    
    // MARK: - Action
    private func startGame() {
        game.startGame()
    }
    
    private func rollSticks() {
        waitingForRollResult = true
        stickNodes.forEach { node in
            let upward = SceneSettings.stickThrowForce
            let at = SceneSettings.stickThrowAt
            node.physicsBody?.applyForce(upward, at: at, asImpulse: true)
            //            node.physicsBody?.applyTorque(SCNVector4(0, 0, 0, 0.5), asImpulse: true)
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
        game.receive(rollResult: result)
        DispatchQueue.main.async {
            self.waitingForRollResult = false
        }
    }
}


// MARK: - Game
extension SceneKitGameViewController: GameDelegate {
    func started(game: Game) {
        os_log(.debug, log: .app, "Game started.")
        descriptionLabel.text = "Game started."
    }
    
    func game(_: Game, switchedTurnTo player: Player) {
        os_log(.debug, log: .app, "Switched to player %{PUBLIC}@.", player.name)
        turnLabel.text = "Player \(player.name)'s"
        descriptionLabel.text = "Player \(player.name)'s turn!"
    }
    
    func game(_: Game, waitingRollFrom player: Player) {
        os_log(.debug, log: .app, "Waiting roll from player %{PUBLIC}@.", player.name)
        if game.pieceMover.remainingSteps.count > 1 {
            descriptionLabel.text = "Extra roll chance! Wating for player \(player.name) to roll!"
        } else {
            descriptionLabel.text = "Wating for player \(player.name) to roll!"
        }
    }
    
    func game(_: Game, player: Player, canMove steps: [Int], to positions: [BoardPosition]) {
        os_log(.debug, log: .app, "Player %{PUBLIC}@ can go forward %{PUBLIC}@.", player.name, steps.debugDescription)
        os_log(.debug, log: .app, "Player %{PUBLIC}@ can move to %{PUBLIC}@.", player.name, positions.debugDescription)
        
        if steps.count > 0 {
            var stepString = steps.reduce("") { (string, step) -> String in
                return string + "\(step), "
            }
            stepString.removeLast()
            stepString.removeLast()
            descriptionLabel.text = "Player \(player.name) can go forward \(stepString) steps."
        }
        
        positions.forEach { position in
            guard let node = scene.rootNode.childNode(withName: position.name, recursively: true) else {
                return
            }
            let box = SCNSphere(radius: 0.1)
            box.firstMaterial = SCNMaterial()
            box.firstMaterial?.emission.contents = UIColor.red
            box.firstMaterial?.transparency = 0.5
            let boxNode = SCNNode(geometry: box)
            boxNode.name = SceneSettings.helpStationNodeName + position.name
            node.addChildNode(boxNode)
            
            helpNodes.append(boxNode)
        }
    }
    
    func game(_: Game, player: Player, pieces: [Piece], movedTo position: BoardPosition) {
        os_log(.debug, log: .app, "Player %{PUBLIC}@ moved to to %{PUBLIC}@.", player.name, position.debugDescription)
        let tokens = tokenNodes.filter { pieces.map { $0.identifier }.contains($0.name?.replacingOccurrences(of: SceneSettings.tokenNodeName, with: "")) }
        if let station = scene.rootNode.childNode(withName: position.name, recursively: true)?.position {
            tokens.forEach {
                $0.position = station
            }
        }
    }
    
    func game(_: Game, eatenPieces: [Piece]) {
        os_log(.debug, log: .app, "%{PUBLIC} pieces are eaten and are returned to home.", eatenPieces.debugDescription)
        let pieces = eatenPieces.map { ($0.name, $0.player) }
        if let player = eatenPieces.first?.player {
            descriptionLabel.text = "\(pieces.count) pieces of player \(player.name) are caught. Extra roll chance!"
        } else {
            descriptionLabel.text = "\(pieces.count) pieces are caught. Extra roll chance!"
        }
    }
    
    func game(_: Game, wonBy player: Player) {
        os_log(.debug, log: .app, "Game ended with winner player %{PUBLIC}@.", player.name)
        descriptionLabel.text = "Player \(player.name) won!"
    }
}

// MARK - Scene
extension SceneKitGameViewController: SCNSceneRendererDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        checkRollResult()
    }
}
