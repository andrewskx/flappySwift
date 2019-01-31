//
//  TestScene.swift
//  Flappy Bosc
//
//  Created by Boscanean Andrian on 1/31/19.
//  Copyright © 2019 Andrian Boscanean. All rights reserved.
//

import SpriteKit

class TestScene: SKScene {
    
    var bg: SKSpriteNode = {
        let node = SKSpriteNode()
        for i in 0..<2 {
            let bg = SKSpriteNode(texture: SKTexture(imageNamed: "bg"))
            bg.name = "background"
            bg.blendMode = .replace
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0)
            bg.zPosition = ZPozition.background
            node.addChild(bg)
        }
        return node
    }()
    
    lazy var action = SKAction.moveTo(x: -self.frame.width, duration: 4)
    lazy var relocate = SKAction.run {
        print("run")
        self.bg.enumerateChildNodes(withName: "background", using: { (node, pointer) in
            if let bg = node as? SKSpriteNode {
                if bg.position.x <= -bg.size.width {
                    bg.position = CGPoint(x: bg.size.width - 2, y: bg.position.y)
                    return
                }
            }
        })
    }
    
    lazy var seq = SKAction.sequence([self.action, self.relocate])
    
    
    override func didMove(to view: SKView) {
        backgroundColor = .red
        addChild(bg)
        bg.run(SKAction.repeatForever(seq))
    }
    
}
