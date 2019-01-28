//
//  Piller+Coin.swift
//  Flappy Bosc
//
//  Created by Boscanean Andrian on 1/8/19.
//  Copyright © 2019 Andrian Boscanean. All rights reserved.
//

import Foundation
import SpriteKit

class Challenge: SKNode {
    let _top: SKSpriteNode = {
        let node = SKSpriteNode(texture: SKTexture(imageNamed: "piller"))
        node.zRotation = CGFloat.pi
        node.setScale(0.5)
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionBitMask.pillar
        node.physicsBody?.collisionBitMask = CollisionBitMask.bird
        node.physicsBody?.contactTestBitMask = CollisionBitMask.bird
        node.zPosition = ZPozition.challenge
        return node
    }()
    
    let _bottom: SKSpriteNode = {
        let node = SKSpriteNode(texture: SKTexture(imageNamed: "piller"))
        node.setScale(0.5)
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionBitMask.pillar
        node.physicsBody?.collisionBitMask = CollisionBitMask.bird
        node.physicsBody?.contactTestBitMask = CollisionBitMask.bird
        node.zPosition = ZPozition.challenge
        return node
    }()
    
    let _coin: SKSpriteNode = {
        let node = SKSpriteNode(texture: SKTexture(imageNamed: "flower"))
        node.size = CGSize(width: 50, height: 50)
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionBitMask.coin
        node.physicsBody?.collisionBitMask = 0
        node.physicsBody?.contactTestBitMask = CollisionBitMask.bird
        node.zPosition = ZPozition.challenge + 0.2
        return node
    }()
    
    init(midFrameX: CGFloat, midFrameY: CGFloat) {
        super.init()
        _top.position = CGPoint(x: midFrameX, y: midFrameY + 420)
        _bottom.position = CGPoint(x: midFrameX, y: midFrameY - 420)
        _coin.position = CGPoint(x: midFrameX, y: midFrameY)
        addChild(_top)
        addChild(_bottom)
        addChild(_coin)
        name = "challenge"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Memory freed")
    }
}
