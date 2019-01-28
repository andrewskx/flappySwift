//
//  CGFloat.swift
//  Flappy Bosc
//
//  Created by Boscanean Andrian on 1/7/19.
//  Copyright © 2019 Andrian Boscanean. All rights reserved.
//

import SpriteKit

extension CGFloat {
    static func random(lower: CGFloat, upper: CGFloat) -> CGFloat{
             return random() * (upper - lower) + lower
    }
    
    static func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
}
