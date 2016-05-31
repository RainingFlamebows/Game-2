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
    var numUnlockedQueues: Int
    let health: Int
    var currentHealth: Int
    
    var baseMenu: SKSpriteNode!
    var baseSprite: SKSpriteNode
    
    var miniBaseMenu: SKSpriteNode!     // menu that opposing player sees when they tap base
    
    var pieces: Array = [SKSpriteNode]()
    var trainingQueue: Array = [Queue]()
    init (ownerIn: Int, rowIn: Int, colIn: Int, health: Int = 20, numUnlockedQueuesIn: Int = 1)
    {
        owner = ownerIn
        row = rowIn
        col = colIn
        numUnlockedQueues = numUnlockedQueuesIn
        self.health = health
        currentHealth = health
        
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
        createMiniBaseMenu()
    }
    
    func createBaseMenu()
    {
        baseMenu = SKSpriteNode(color: SKColor.lightGrayColor(), size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 200.0))

        baseMenu.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        baseMenu.position = CGPoint(x: 0, y: -screenMidY+baseMenu.frame.height/2.0)
        baseMenu.zPosition = 10
        
        let menuHeight = baseMenu.frame.height
        
        // displays "Health"
        let healthLabel = SKLabelNode()
        healthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        healthLabel.verticalAlignmentMode = .Center
        healthLabel.fontName = "Avenier-Light"
        healthLabel.fontSize = 20
        healthLabel.position = CGPointMake(-screenMidX/4, menuHeight/2.6)
        healthLabel.text = "Health: "
        baseMenu.addChild(healthLabel)
        
        // displays currentHealth
        let currentHealthLabel = SKLabelNode()
        currentHealthLabel.name = "currentHealthLabel"
        currentHealthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        currentHealthLabel.verticalAlignmentMode = .Center
        currentHealthLabel.fontName = "Avenier-Light"
        currentHealthLabel.fontSize = 20
        currentHealthLabel.position = CGPointMake(0, menuHeight/2.6)
        currentHealthLabel.fontColor = customGreen
//        currentHealthLabel.text = String(currentHealth)
        currentHealthLabel.text = " \(currentHealth)"
        baseMenu.addChild(currentHealthLabel)
        
        let totalHealthLabel = SKLabelNode()
        totalHealthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        totalHealthLabel.verticalAlignmentMode = .Center
        totalHealthLabel.fontName = "Avenier-Light"
        totalHealthLabel.fontSize = 20
        totalHealthLabel.position = CGPointMake(10, menuHeight/2.6)
        totalHealthLabel.text = "/\(health)"
        baseMenu.addChild(totalHealthLabel)

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
            queue.outerSprite.position = CGPointMake(-screenMidX + margin + CGFloat(i)*(margin/2 + queue.outerSprite.frame.width), menuHeight/4)
            baseMenu.addChild(queue.outerSprite)
            
            queue.innerSprite.name = "inner sprite"
            queue.innerSprite.size = CGSizeMake(spaceForQueue/CGFloat(numQueue), spaceForQueue/CGFloat(numQueue))
            queue.innerSprite.anchorPoint = CGPointMake(0,1)
            if(i >= numUnlockedQueues) {
                queue.innerSprite.texture = SKTexture(imageNamed: "lock")
                queue.isLocked = true
            }
			queue.outerSprite.addChild(queue.innerSprite)

			let timeLeftLabel = SKLabelNode()
			timeLeftLabel.name = "timeLeftLabel " + String(i)
			timeLeftLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
			timeLeftLabel.fontSize = 12
			timeLeftLabel.fontName = "Avenir-Medium"
            timeLeftLabel.position = CGPointMake(-3, margin/4)
//			timeLeftLabel.position = CGPointMake(queue.outerSprite.frame.midX, baseMenu.frame.height/2 - 30)
			queue.timeLeftLabel = timeLeftLabel
			queue.outerSprite.addChild(timeLeftLabel)

			let statusLabel = SKLabelNode()
			statusLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
			statusLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
			statusLabel.fontName = "Avenir-Light"
			statusLabel.fontSize = 13
			statusLabel.position = CGPointMake(queue.outerSprite.frame.midX, queue.outerSprite.frame.midY)
			queue.statusLabel = statusLabel
			baseMenu.addChild(statusLabel)

            trainingQueue.append(queue)
        }
        
        var color = "red"
        if(owner == 1) {
            color = "red"
        }
        else if(owner == 2) {
            color = "blue"
        }
        

        let numPieces = 5
        
        var index = CGFloat(0)
        let warriorSprite = SKSpriteNode(imageNamed: "warrior sprite " + color)
        warriorSprite.name = "warrior"
        warriorSprite.anchorPoint = CGPointMake(0,0)
        warriorSprite.size = CGSizeMake(spaceForQueue/CGFloat(numPieces), spaceForQueue/CGFloat(numPieces))
        warriorSprite.position = CGPointMake(-screenMidX + margin + CGFloat(index)*(margin/2 + warriorSprite.frame.width), -menuHeight/2.7)
        baseMenu.addChild(warriorSprite)

		let warriorLabel = SKLabelNode(text: "Warrior")
		warriorLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
		warriorLabel.fontSize = 15
		warriorLabel.fontName = "Avenir-Medium"
		warriorLabel.position = CGPointMake(warriorSprite.frame.midX, warriorSprite.frame.midY - 50)
		baseMenu.addChild(warriorLabel)

        
        index += 1
        let defenderSprite = SKSpriteNode(imageNamed: "defender sprite " + color)
        defenderSprite.name = "defender"
        defenderSprite.anchorPoint = CGPointMake(0,0)
        defenderSprite.size = CGSizeMake(spaceForQueue/CGFloat(numPieces), spaceForQueue/CGFloat(numPieces))
        defenderSprite.position = CGPointMake(-screenMidX + margin + CGFloat(index)*(margin/2 + defenderSprite.frame.width), -menuHeight/2.7)
        baseMenu.addChild(defenderSprite)

		let defenderLabel = SKLabelNode(text: "Defender")
		defenderLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
		defenderLabel.fontSize = 15
		defenderLabel.fontName = "Avenir-Medium"
		defenderLabel.position = CGPointMake(defenderSprite.frame.midX, defenderSprite.frame.midY - 50)
		baseMenu.addChild(defenderLabel)


        index += 1
        let rangerSprite = SKSpriteNode(imageNamed: "ranger sprite " + color)
        rangerSprite.name = "ranger"
        rangerSprite.anchorPoint = CGPointMake(0,0)
        rangerSprite.size = CGSizeMake(spaceForQueue/CGFloat(numPieces), spaceForQueue/CGFloat(numPieces))
        rangerSprite.position = CGPointMake(-screenMidX + margin + CGFloat(index)*(margin/2 + rangerSprite.frame.width), -menuHeight/2.7)
        baseMenu.addChild(rangerSprite)

		let rangerLabel = SKLabelNode(text: "Ranger")
		rangerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
		rangerLabel.fontSize = 15
		rangerLabel.fontName = "Avenir-Medium"
		rangerLabel.position = CGPointMake(rangerSprite.frame.midX, rangerSprite.frame.midY - 50)
		baseMenu.addChild(rangerLabel)

        
        index += 1
        let mageSprite = SKSpriteNode(imageNamed: "mage sprite " + color)
        mageSprite.name = "mage"
        mageSprite.anchorPoint = CGPointMake(0,0)
        mageSprite.size = CGSizeMake(spaceForQueue/CGFloat(numPieces), spaceForQueue/CGFloat(numPieces))
        mageSprite.position = CGPointMake(-screenMidX + margin + CGFloat(index)*(margin/2 + mageSprite.frame.width), -menuHeight/2.7)
        baseMenu.addChild(mageSprite)


		let mageLabel = SKLabelNode(text: "Mage")
		mageLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
		mageLabel.fontSize = 15
		mageLabel.fontName = "Avenir-Medium"
		mageLabel.position = CGPointMake(mageSprite.frame.midX, mageSprite.frame.midY - 50)
		baseMenu.addChild(mageLabel)
        
        pieces.append(warriorSprite)
        pieces.append(defenderSprite)
        pieces.append(rangerSprite)
        pieces.append(mageSprite)

    }
    
    func createMiniBaseMenu() {
        miniBaseMenu = SKSpriteNode(color: SKColor.lightGrayColor(), size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 100))
        miniBaseMenu.anchorPoint = baseMenu.anchorPoint
        miniBaseMenu.position = CGPoint(x: 0, y: -screenMidY+miniBaseMenu.frame.height/2.0)
        miniBaseMenu.zPosition = baseMenu.zPosition
        
        let miniMenuHeight = miniBaseMenu.frame.height
        
        
        // I would directly add the same healthLabels created in createBaseMenu except Swift crashes when
        // you try to add the same SKNode to 2 different SKNodes (basemenu and minibasemenu)
        // displays "Health"
        let healthLabel = SKLabelNode()
        healthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        healthLabel.verticalAlignmentMode = .Center
        healthLabel.fontName = "Avenier-Light"
        healthLabel.fontSize = 20
        healthLabel.position = CGPointMake(-screenMidX/4, 0)
        healthLabel.text = "Health: "
        miniBaseMenu.addChild(healthLabel)
        
        // displays currentHealth
        let currentHealthLabel = SKLabelNode()
        currentHealthLabel.name = "currentHealthLabel"
        currentHealthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        currentHealthLabel.verticalAlignmentMode = .Center
        currentHealthLabel.fontName = "Avenier-Light"
        currentHealthLabel.fontSize = 20
        currentHealthLabel.position = CGPointMake(0, 0)
        currentHealthLabel.fontColor = customGreen
        //        currentHealthLabel.text = String(currentHealth)
        currentHealthLabel.text = " \(currentHealth)"
        miniBaseMenu.addChild(currentHealthLabel)
        
        let totalHealthLabel = SKLabelNode()
        totalHealthLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        totalHealthLabel.verticalAlignmentMode = .Center
        totalHealthLabel.fontName = "Avenier-Light"
        totalHealthLabel.fontSize = 20
        totalHealthLabel.position = CGPointMake(10, 0)
        totalHealthLabel.text = "/\(health)"
        miniBaseMenu.addChild(totalHealthLabel)
        
        let cancelButton = SKSpriteNode(imageNamed: "cancel icon")
        cancelButton.position = CGPointMake(screenMidX - 8, miniMenuHeight/2 - 8)
        cancelButton.anchorPoint = CGPointMake(1.0, 1.0)
        cancelButton.size = CGSize(width: 18, height: 18)
        cancelButton.name = "cancel button"
        miniBaseMenu.addChild(cancelButton)
        
//        let baseSpriteThumbnail = String(self.dynamicType).lowercaseString
        var sprite = SKSpriteNode(imageNamed: "red base")
        if(owner == 1) {
            sprite = SKSpriteNode(imageNamed: "red base")
        }
        else if(owner == 2) {
            sprite = SKSpriteNode(imageNamed: "blue base")
        }
        sprite.position = CGPointMake(-4.2/6*screenMidX, 0)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sprite.size = CGSize(width: 1.9/6*screenMidX, height: 1.9/6*screenMidX)
        miniBaseMenu.addChild(sprite)
    }
    
    func updateBaseMenu() {
        var healthLabelColor = SKColor()
        if(currentHealth < health/3) {
            healthLabelColor = customRed
        }
        else if(currentHealth < health/2) {
            healthLabelColor = customYellow
        }
        else {
            healthLabelColor = customGreen
        }
        
        (baseMenu.childNodeWithName("currentHealthLabel") as! SKLabelNode).text = String(currentHealth)
        (baseMenu.childNodeWithName("currentHealthLabel") as! SKLabelNode).fontColor = healthLabelColor
    }
    
    func getAvailableQueue() -> Queue? {
        var index = 0
        while(index < trainingQueue.count && (trainingQueue[index].trainingTimeLeft != -1 && trainingQueue[index].canChange == false)) {
            index += 1
        }
        if(index >= trainingQueue.count || trainingQueue[index].canChange == false) {
            return nil
        }
        else {
            return trainingQueue[index]
        }
    }
    
	    
    func displayPiece(theSprite: SKSpriteNode, position: CGPoint, size: CGSize, menu: SKSpriteNode) {
        theSprite.size = size
        theSprite.position = position
        menu.addChild(theSprite)
    }

    func nextRound(territory: Int, totalTerritory: Int) {
        let percentTerritoryTaken = CGFloat(territory)/CGFloat(totalTerritory)
        if percentTerritoryTaken > 0.8 {
            numUnlockedQueues = 5
        }
        else if percentTerritoryTaken > 0.45 {
            numUnlockedQueues = 4
        }
        else if percentTerritoryTaken > 0.2 {
            numUnlockedQueues = 3
        }
        else if percentTerritoryTaken > 0.05 {
            numUnlockedQueues = 2
        }
        else {
            numUnlockedQueues = 1
        }
        
        for i in 0..<numQueue {
            if(i <= numUnlockedQueues && trainingQueue[i].trainingTimeLeft == -1) {
                trainingQueue[i].innerSprite.texture = nil
                trainingQueue[i].isLocked = false
            }
        }
        
        for q in trainingQueue {
            if q.trainingTimeLeft > 1 {
                q.trainingTimeLeft -= 1
                q.timeLeftLabel.text = "\(q.trainingTimeLeft) turn(s) left"
                q.canChange = false
            }
            else {
                if q.isLocked == false {
                    q.statusLabel.text = "ready!"
                    q.timeLeftLabel.text = ""
                    q.canChange = true
                }
            }
        }
	}
}


class Queue {
    var isLocked: Bool = false
	var canChange: Bool = true
    var trainingTimeLeft: Int     // -1 means queue is not occupied
    var outerSprite: SKSpriteNode = SKSpriteNode(imageNamed: "dead")
    var innerSprite: SKSpriteNode = SKSpriteNode()
	var timeLeftLabel: SKLabelNode = SKLabelNode()
	var statusLabel: SKLabelNode = SKLabelNode()
    var owner: Int
	var thePiece: Piece?

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
        else if(thePieceSprite.name == "defender") {
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
			timeLeftLabel.text = ""
            statusLabel.text = ""
        }

		if trainingTimeLeft != -1 {
			timeLeftLabel.text = "\(trainingTimeLeft) turn(s) left"
			statusLabel.text = "training..."
		}

		self.thePiece = thePiece
    }
}

