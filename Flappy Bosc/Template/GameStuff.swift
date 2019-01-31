//
//  GameStuff.swift
//  Flappy Bosc
//
//  Created by Boscanean Andrian on 1/7/19.
//  Copyright © 2019 Andrian Boscanean. All rights reserved.
//

import Foundation
import SpriteKit

enum GameState {
    case initial, playing, pause, restart, resume, dying
}

struct CollisionBitMask {
    static let  bird:   UInt32  = 0x1
    static let  coin:   UInt32  = 0x1 << 1
    static let  pillar: UInt32  = 0x1 << 2
    static let  ground: UInt32  = 0x1 << 3
}

struct ZPozition {
    static let background:  CGFloat = 0
    static let challenge:   CGFloat = 1
    static let score:       CGFloat = 2
    static let bird:        CGFloat = 3
    static let button:      CGFloat = 4
}
