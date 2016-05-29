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
    let numUnlockedQueues: Int
    
    var baseMenu: SKSpriteNode!
    var baseSprite: SKSpriteNode
    
    var pieces: Array = [SKSpriteNode]()
    var trainingQueue: Array = [Queue]()
    init (ownerIn: Int, rowIn: Int, colIn: Int, numUnlockedQueuesIn: Int = 1)
    {
        owner = ownerIn
        row = rowIn
        col = colIn
        numUnlockedQueues = numUnlockedQueuesIn
        
        if(owner == 1) {
            baseSprite = SKSpriteNode(imageNamed: "red base")
        }
        else if(owner == 2) {
            baseSprite = SKSpriteNode(imageNamed: "blue base")
        }
        else {
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
            let queue = Queue(ownerIn: self.owner)
            queue.outerSprite.name = "queue " + String(i)
            queue.outerSprite.anchorPoint = CGPointMake(0, 1)
            queue.outerSprite.size = CGSizeMake(spaceForQueue/CGFloat(numQueue), spaceForQueue/CGFloat(numQueue))
            queue.outerSprite.position = CGPointMake(-screenMidX + margin + CGFloat(i)*(margin/2 + queue.outerSprite.frame.width), menuHeight/3)
            baseMenu.addChild(queue.outerSprite)
            
            queue.innerSprite.name = "inner sprite"
            queue.innerSprite.size = CGSizeMake(spaceForQueue/CGFloat(numQueue), spaceForQueue/CGFloat(numQueue))
            queue.innerSprite.anchorPoint = CGPointMake(0,1)
            if(i >= numUnlockedQueues) {
                queue.innerSprite.texture = SKTexture(imageNamed: "lock")
                queue.isLocked = true
            }
            
            queue.outerSprite.addChild(queue.innerSprite)
            trainingQueue.append(queue)
        }
        
        var color = "red"
        if(owner == 1) {
            color = "red"
        }
        else if(owner == 2) {
            color = "blue"
        }
        

        let numPieces = 4
        
        //I know hardcoding this is really bad, but if you have any better ideas on how to do this feel free to change it
        var index = CGFloat(0)
        let warriorSprite = SKSpriteNode(imageNamed: "warrior sprite " + color)
        warriorSprite.name = "warrior"
        warriorSprite.anchorPoint = CGPointMake(0,0)
        warriorSprite.size = CGSizeMake(spaceForQueue/CGFloat(numPieces), spaceForQueue/CGFloat(numPieces))
        warriorSprite.position = CGPointMake(-screenMidX + margin + CGFloat(index)*(margin/2 + warriorSprite.frame.width), -menuHeight/2.7)
        baseMenu.addChild(warriorSprite)
        
        index += 1
        let defenderSprite = SKSpriteNode(imageNamed: "defender sprite " + color)
        defenderSprite.name = "defender"
        defenderSprite.anchorPoint = CGPointMake(0,0)
        defenderSprite.size = CGSizeMake(spaceForQueue/CGFloat(numPieces), spaceForQueue/CGFloat(numPieces))
        defenderSprite.position = CGPointMake(-screenMidX + margin + CGFloat(index)*(margin/2 + defenderSprite.frame.width), -menuHeight/2.7)
        baseMenu.addChild(defenderSprite)
        
        index += 1
        let rangerSprite = SKSpriteNode(imageNamed: "ranger sprite " + color)
        rangerSprite.name = "ranger"
        rangerSprite.anchorPoint = CGPointMake(0,0)
        rangerSprite.size = CGSizeMake(spaceForQueue/CGFloat(numPieces), spaceForQueue/CGFloat(numPieces))
        rangerSprite.position = CGPointMake(-screenMidX + margin + CGFloat(index)*(margin/2 + rangerSprite.frame.width), -menuHeight/2.7)
        baseMenu.addChild(rangerSprite)
        
        index += 1
        let mageSprite = SKSpriteNode(imageNamed: "mage sprite " + color)
        mageSprite.name = "mage"
        mageSprite.anchorPoint = CGPointMake(0,0)
        mageSprite.size = CGSizeMake(spaceForQueue/CGFloat(numPieces), spaceForQueue/CGFloat(numPieces))
        mageSprite.position = CGPointMake(-screenMidX + margin + CGFloat(index)*(margin/2 + mageSprite.frame.width), -menuHeight/2.7)
        baseMenu.addChild(mageSprite)
        
        pieces.append(warriorSprite)
        pieces.append(defenderSprite)
        pieces.append(rangerSprite)
        pieces.append(mageSprite)
        ///////////// END BAD PROGRAMMING
        
    }
    
    func getAvailableQueue() -> Queue? {
        var index = 0
        while(index < trainingQueue.count && trainingQueue[index].trainingTimeLeft != -1 && trainingQueue[index].isLocked) {
            index += 1
        }
        if(index >= trainingQueue.count) {
            return nil
        }
        else {
            return trainingQueue[index]
        }
    }
    
	func touchedInsideBase(locationInStatusBar: CGPoint)
	{
        for piece in pieces {
            if(piece.containsPoint(locationInStatusBar)) {
                var availableQueue = getAvailableQueue()
                if(availableQueue != nil) {
//                    availableQueue!.innerSprite.texture = piece.texture
                    availableQueue!.addPieceToQueue(piece)
                }
                else {
                    print("no more spaces left in queue")
                }
                availableQueue = nil
            }
        }
	}
    
    func displayPiece(theSprite: SKSpriteNode, position: CGPoint, size: CGSize, menu: SKSpriteNode) {
        theSprite.size = size
        theSprite.position = position
        menu.addChild(theSprite)
    }
}


class Queue {
    var isLocked: Bool = false
    var trainingTimeLeft: Int     // -1 means queue is not occupied
    var outerSprite: SKSpriteNode = SKSpriteNode(imageNamed: "dead")
    var innerSprite: SKSpriteNode = SKSpriteNode()
    var owner: Int
    init(trainingTime: Int = -1, ownerIn: Int) {
        trainingTimeLeft = trainingTime
        self.owner = ownerIn
    }
    
    func addPieceToQueue(thePieceSprite: SKSpriteNode) {
        var thePiece: Piece?
        innerSprite.texture = thePieceSprite.texture
        isLocked = false
        if(thePieceSprite.name == "warrior") {
            thePiece = Warrior(owner: self.owner, row: 0, column: 0)
            self.trainingTimeLeft = (thePiece?.trainingTime)!
        }
        if(thePieceSprite.name == "defender") {
            thePiece = Defender(owner: self.owner, row: 0, column: 0)
            self.trainingTimeLeft = (thePiece?.trainingTime)!
        }
        else if(thePieceSprite.name == "ranger") {
            thePiece = Ranger(owner: self.owner, row: 0, column: 0)
            self.trainingTimeLeft = (thePiece?.trainingTime)!
        }
        else if(thePieceSprite.name == "mage") {
            thePiece = Mage(owner: self.owner, row: 0, column: 0)
            self.trainingTimeLeft = (thePiece?.trainingTime)!
        }
        else {
            thePiece = nil
            self.trainingTimeLeft = -1
            
        }
    }
}

