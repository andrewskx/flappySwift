//
//  FlappyScene.swift
//  Flappy Bosc
//
//  Created by Boscanean Andrian on 1/8/19.
//  Copyright © 2019 Andrian Boscanean. All rights reserved.
//

import SpriteKit

class FlappyScene: SKScene {
    
    @objc func handleEnterBackground() {
        guard playing else { return }
        print("background")
        pauseState()
    }
    
    lazy var bird: SKSpriteNode = {
        let bird = SKSpriteNode(texture: SKTexture(imageNamed: "bird1"))
        bird.name = "bird"
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.size = CGSize(width: 40, height: 40)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = false
        bird.physicsBody?.allowsRotation = false
        bird.zPosition = ZPozition.bird
        bird.isPaused = true
        
        return bird
    }()
    
    lazy var pauseBtn: SKSpriteNode = {
        let btn = SKSpriteNode(texture: SKTexture(imageNamed: "pause"))
        btn.size = CGSize(width: 40, height: 40)
        btn.zPosition = ZPozition.button
        btn.isHidden = true
        
        return btn
    }()
    
    lazy var restartBtn: SKSpriteNode = {
        let btn = SKSpriteNode(texture: SKTexture(imageNamed: "restart"))
        btn.zPosition = ZPozition.button
        btn.size = CGSize(width: 60, height: 60)
        btn.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 30)
        btn.isHidden = true
        
        return btn
    }()
    
    lazy var highscoreLbl: SKLabelNode = {
        let lbl = SKLabelNode(fontNamed: "AvenirNext-Medium")
        lbl.zPosition = ZPozition.score
        lbl.isHidden = true
        return lbl
    }()
    
    lazy var tapToPlayLbl: SKLabelNode = {
        let lbl = SKLabelNode(text: "Tap To Play")
        lbl.fontName = "AvenirNext-Bold"
        lbl.fontSize = 24
        lbl.zPosition = ZPozition.score
        lbl.isHidden = true
        lbl.isPaused = true
        
        return lbl
    }()
    
    lazy var currentScoreLbl: SKLabelNode = {
        let lbl = SKLabelNode(text: "0")
        lbl.zPosition = ZPozition.score
        let yPos = (self.frame.maxY + self.frame.midY) / 1.8
        lbl.position = CGPoint(x: self.frame.midX, y: yPos)
        lbl.fontName = "AvenirNext-Bold"
        lbl.fontSize = 36
        lbl.verticalAlignmentMode = .center
        lbl.isHidden = true
        
        let shapeBg = SKShapeNode(circleOfRadius: 45)
        shapeBg.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        shapeBg.strokeColor = .clear
        lbl.addChild(shapeBg)
        return lbl
    }()
    
    var score: Int = 0 {
        didSet {
            let highscore = UserDefaults.standard.integer(forKey: "highscore")
            if highscore < score {
                UserDefaults.standard.set(score, forKey: "highscore")
                highscoreLbl.text =  "High score: \(score)"
            }
        }
    }
    var pillersAndCoin: SKNode?
    var playing: Bool = false
    var pause: Bool = false
    var gameState = GameState.initial
    
//    let move = SKAction.moveTo(x: -36, duration: 5)
    
//    let flyAway = SKAction.moveBy(x: 0, y: 250, duration: 0.5)
//    let disappear = SKAction.scale(to: CGSize(width: 0, height: 0), duration: 0.5)
//    lazy var gotCoin = SKAction.group([self.flyAway, self.disappear])
    var gotCoin = SKAction.group([SKAction.moveBy(x: 0, y: 250, duration: 0.5), SKAction.scale(to: .zero, duration: 0.5)])

    
//    let remove = SKAction.removeFromParent()
//    lazy var seq = SKAction.sequence([self.move, self.remove])
    lazy var seq = SKAction.sequence([SKAction.moveTo(x: -36, duration: TimeInterval(self.frame.width / 2 / 60)), SKAction.removeFromParent()])

    
    func generate() {
        pillersAndCoin = Challenge(midFrameX: 0, midFrameY: frame.midY)
        let randomY = CGFloat.random(lower: -100, upper: 100)
        pillersAndCoin?.position.x = frame.maxX + 25
        pillersAndCoin?.position.y += randomY
        pillersAndCoin?.run(seq, withKey: "moveingChallenge")
        addChild(pillersAndCoin!)
    }
    
    lazy var generateAction = SKAction.run {
        self.generate()
    }
    
    let delay = SKAction.wait(forDuration: 2)
    
    var inset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            if let inset = self.view?.safeAreaInsets {
                return inset
            }
            else {
                return .zero
            }
        } else {
            return .zero
        }
    }
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(handleEnterBackground),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        setupScene()
        initialState()
        backgroundColor = .red
        //need to delete
        self.run(SKAction.run { self.safeInset() })
    }
    
    //need to delete
    func safeInset() {
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30 + inset.bottom)
    }
    
    func setupBackground() {
        for i in 0..<2 {
            let bg = SKSpriteNode(texture: SKTexture(imageNamed: "bg"))
            bg.name = "background"
            bg.blendMode = .replace
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0)
            bg.zPosition = ZPozition.background
            addChild(bg)
        }
    }
    
    func setupScene() {
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody?.categoryBitMask = CollisionBitMask.ground
        physicsBody?.collisionBitMask = CollisionBitMask.bird
        physicsBody?.contactTestBitMask = CollisionBitMask.bird
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        addChild(tapToPlayLbl)
        addChild(highscoreLbl)
        addChild(bird)
        addChild(restartBtn)
        addChild(pauseBtn)
        addChild(currentScoreLbl)
    }
    
    func setupBirdAnimation() {
        let atlas = SKTextureAtlas(named: "player")
        var textureArray = [SKTexture]()
        for orderOfTexture in 1...atlas.textureNames.count {
            let textureForIndex = "bird\(orderOfTexture)"
            textureArray.append(SKTexture(imageNamed: textureForIndex))
        }
        let animateTextures = SKAction.animate(with: textureArray, timePerFrame: 0.1)
        bird.isPaused = false
        bird.run(SKAction.repeatForever(animateTextures))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // handle background animation
        guard playing else { return }
        let rotation = (bird.physicsBody?.velocity.dy)! * ((bird.physicsBody?.velocity.dy)! < 0 ? 0.003 : 0.001)
        bird.zRotation = CGFloat(min(max(-1, rotation), 0.5))
        enumerateChildNodes(withName: "background") { (node, something) in
            if let bg = node as? SKSpriteNode {
                bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                if bg.position.x <= -bg.size.width {
                    bg.position = CGPoint(x: bg.size.width - 2, y: bg.position.y)
                }
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            switch gameState {
            case .initial:
                print("\(gameState)")
                playingState()
                bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
                return
            case .playing:
                print("\(gameState)")
                if pauseBtn.frame.contains(location) {
                    pauseState()
                } else {
                    bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
                }
                return
            case .pause:
                print("\(gameState)")
                if pauseBtn.frame.contains(location) {
                    resumeState()
                } else if restartBtn.frame.contains(location){
                    restartState()
                }
                return
            default:
                continue
            }
        }
    }
}

extension FlappyScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node, let bodyB = contact.bodyB.node else {return}
        let objectA = bodyA.name == "bird" ? bodyA : bodyB
        let objectB = bodyA.name != "bird" ? bodyA : bodyB
        
        switch (objectA.physicsBody?.categoryBitMask, objectB.physicsBody?.categoryBitMask) {
        case (CollisionBitMask.bird, CollisionBitMask.pillar):
            gameState = .dying
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
            removeAction(forKey: "generate")
            enumerateChildNodes(withName: "challenge") { (node, pointer) in
                    node.isPaused = true
                }
            objectA.physicsBody?.categoryBitMask = 0
            objectA.physicsBody?.collisionBitMask = 0
            objectA.physicsBody?.contactTestBitMask = 0
            run(SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.run{self.restartState()}]))
            playing = false
            bird.physicsBody?.allowsRotation = true
            bird.run(SKAction.rotate(toAngle: -.pi / 2, duration: 0.3))
        case (CollisionBitMask.bird, CollisionBitMask.coin):
            objectB.physicsBody?.categoryBitMask = 0
            objectB.run(gotCoin)
            score += 1
            currentScoreLbl.text = String(score)
            print("Bird and Coin")
        case (CollisionBitMask.bird, CollisionBitMask.ground):
            print("Bird and ground")
        default:
            print(objectA.physicsBody?.categoryBitMask ?? 0, objectB.physicsBody?.categoryBitMask ?? 0)
        }
    }
}


extension FlappyScene {
    func initialState() {
        bird.physicsBody?.categoryBitMask = CollisionBitMask.bird
        bird.physicsBody?.collisionBitMask = CollisionBitMask.ground | CollisionBitMask.pillar
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.coin | bird.physicsBody!.collisionBitMask
        bird.zRotation = 0
        gameState = .initial
        setupBirdAnimation()
        setupBackground()
        tapToPlayLbl.isPaused = false
        tapToPlayLbl.isHidden = false
        tapToPlayLbl.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 50)
        let zoomIn = SKAction.scale(to: 1.1, duration: 0.5)
        let zoomOut = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([zoomIn, zoomOut])
        tapToPlayLbl.run(SKAction.repeatForever(sequence))

        let yPos = (self.frame.maxY + self.frame.midY) / 2
        highscoreLbl.position = CGPoint(x: self.frame.midX, y: yPos)
        let highscore = UserDefaults.standard.integer(forKey: "highscore")
        highscoreLbl.text = "High score: \(highscore)"
        highscoreLbl.run(SKAction.scale(to: 1.0, duration: 0.2))
        highscoreLbl.fontSize = 24
        highscoreLbl.isHidden = false
    }
    
    func playingState() {
        gameState = .playing
        playing = true
        currentScoreLbl.text = "0"
        score = 0
        let scaleDown = SKAction.scale(to: 0.6, duration: 0.3)
        let translate = SKAction.move(to: CGPoint(x: self.frame.width - highscoreLbl.frame.width / 2,
                                                  y: self.frame.height - currentScoreLbl.frame.height / 2 - inset.top),
                                      duration: 0.3)
        highscoreLbl.run(SKAction.group([scaleDown, translate])) {
            self.currentScoreLbl.isHidden = false
        }
        tapToPlayLbl.run(SKAction.scale(to: 0.5, duration: 0.3)) {
            self.tapToPlayLbl.isHidden = true
        }
        pauseBtn.isHidden = false
        bird.physicsBody?.affectedByGravity = true
        bird.physicsBody?.isDynamic = true
        run(SKAction.repeatForever(SKAction.sequence([generateAction, delay])), withKey: "generate")
    }
    
    func pauseState() {
        gameState = .pause
        let generateAction = action(forKey: "generate")
        generateAction?.speed = 0
        let movingChallenge = action(forKey: "movingChallenge")
        movingChallenge?.speed = 0
        playing = false
        bird.isPaused = true
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = false
        restartBtn.isHidden = false
        let scaleUp = SKAction.scale(to: CGSize(width: 60, height: 60),
                                     duration: 0.3)
        let translate = SKAction.move(to: CGPoint(x: self.frame.midX, y: restartBtn.position.y - 80),
                                      duration: 0.3)
        pauseBtn.texture = SKTexture(imageNamed: "play")
        pauseBtn.run(SKAction.sequence([translate, scaleUp]))
    }
    
    func resumeState() {
        gameState = .playing
        let generateAction = action(forKey: "generate")
        generateAction?.speed = 1
        let movingChallenge = action(forKey: "movingChallenge")
        movingChallenge?.speed = 1
        pauseBtn.texture = SKTexture(imageNamed: "pause")
        let scaleDown = SKAction.scale(to: CGSize(width: 40, height: 40), duration: 0.3)
        let translate = SKAction.move(to: CGPoint(x: self.frame.maxX - 30, y: 30 + inset.bottom), duration: 0.3)
        restartBtn.isHidden = true
        pauseBtn.run(SKAction.group([scaleDown, translate]))
        bird.physicsBody?.affectedByGravity = true
        bird.physicsBody?.isDynamic = true
        bird.isPaused = false
        playing = true
    }
    
    func restartState() {
        enumerateChildNodes(withName: "challenge") { (node, pointer) in
            node.removeFromParent()
        }
        pauseBtn.isHidden = true
        restartBtn.isHidden = true
        currentScoreLbl.isHidden = true
        bird.removeAllActions()
        enumerateChildNodes(withName: "background") { (node, pointer) in
            node.removeFromParent()
        }
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = false
        bird.run(SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY), duration: 0.3))
        pauseBtn.size = CGSize(width: 40, height: 40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.texture = SKTexture(imageNamed: "pause")
        initialState()
    }
}
