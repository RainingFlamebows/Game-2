//
//  Homebase.swift
//  Game 2
//
//  Created by Elena Ariza on 5/24/16.
//  Copyright © 2016 Elena Ariza and Shannon Shih. All rights reserved.
//

import Foundation
import SpriteKit

class Base {
    
    let owner: Int
    let row: Int
    let col: Int
    
    var baseMenu: SKSpriteNode!
    
    init (ownerIn: Int, rowIn: Int, colIn: Int)
    {
        owner = ownerIn
        row = rowIn
        col = colIn
        
        createBaseMenu()
    }
    
    func createBaseMenu()
    {
        baseMenu = SKSpriteNode(color: SKColor.lightGrayColor(), size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 200.0))

        baseMenu.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        baseMenu.position = CGPoint(x: 0, y: -screenMidY+baseMenu.frame.height/2.0)
        baseMenu.zPosition = 10
        
        let menuHeight = baseMenu.frame.height
        
        let cancelButton = SKSpriteNode(imageNamed: "cancel icon")
        cancelButton.position = CGPointMake(screenMidX - 8, menuHeight/2 - 8)
        cancelButton.anchorPoint = CGPointMake(1.0, 1.0)
        cancelButton.size = CGSize(width: 18, height: 18)
        cancelButton.name = "cancel button"
        baseMenu.addChild(cancelButton)

        
        let queue = SKSpriteNode(imageNamed: "dead")
        queue.anchorPoint = CGPointMake(0.5, 0.5)
        queue.size = CGSizeMake(1/6*screenMidX, 1/6*screenMidX)
        queue.position = CGPointMake(-screenMidX + margin, margin)
        baseMenu.addChild(queue)
        
    }

    
    
}
