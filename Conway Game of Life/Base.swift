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
    
    let numQueue = 5
    let owner: Int
    let row: Int
    let col: Int
    
    var baseMenu: SKSpriteNode!
    var baseSprite: SKSpriteNode
    
    init (ownerIn: Int, rowIn: Int, colIn: Int)
    {
        owner = ownerIn
        row = rowIn
        col = colIn
        
        if(owner == 1) {
            baseSprite = SKSpriteNode(imageNamed: "red base")
        }
        else if(owner == 2) {
            baseSprite = SKSpriteNode(imageNamed: "blue base")
        }
        else {
            print("Warning: base sprite not assigned")
            baseSprite = SKSpriteNode()
        }
        
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

        let spaceForQueue = baseMenu.frame.width - margin*CGFloat(numQueue - 1)
        
        for i in 0..<numQueue {
            let queue = SKSpriteNode(imageNamed: "dead")
            queue.anchorPoint = CGPointMake(0, 1)
            queue.size = CGSizeMake(spaceForQueue/CGFloat(numQueue), spaceForQueue/CGFloat(numQueue))
            queue.position = CGPointMake(-screenMidX + margin + CGFloat(i)*(margin/2 + queue.frame.width), menuHeight/3)
            baseMenu.addChild(queue)
        }
        
    }

    
    
}
