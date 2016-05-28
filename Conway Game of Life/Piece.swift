//
//  File.swift
//  Game 2
//
//  Created by Elena Ariza on 5/13/16.
//  Copyright © 2016 Elena Ariza and Shannon Shih. All rights reserved.
//

import Foundation
import SpriteKit

func == (lhs: Piece, rhs: Piece) -> Bool
{
    return lhs === rhs
}

class Piece: Equatable {
    var row: Int
    var column: Int
    var attack: Int
    var range: Int
    var health: Int
    var currentHealth: Int
    var movement: Int
    
    var isAlive: Bool
    var owner: Int // player 1 = 1, player 2 = 2
    
    var sprite: SKSpriteNode!
    var pieceMenu: SKSpriteNode!
    
    var targets: [SKSpriteNode] = Array()
    var canMove: Bool = true
    
    init(owner: Int, row: Int, column: Int, attack: Int, range: Int, health: Int, movement: Int) {
        self.owner = owner
        self.row = row
        self.column = column
        self.attack = attack
        self.range = range
        self.health = health
        self.movement = movement
        self.isAlive = true
        currentHealth = self.health // piece has max HP by default
        
        
        createPieceMenu()
        
    }
    
    
    func createPieceMenu()
    {
        let screenHeight = UIScreen.mainScreen().bounds.height
        let screenWidth = UIScreen.mainScreen().bounds.width
//        
//        baseMenu = SKSpriteNode(color: SKColor.lightGrayColor(), size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 200.0))
//        
//        baseMenu.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        baseMenu.position = CGPoint(x: 0, y: -screenMidY+baseMenu.frame.height/2.0)
//        baseMenu.zPosition = 10

        
        pieceMenu = SKSpriteNode(color: SKColor.lightGrayColor(), size: CGSize(width: screenWidth, height: 100))
        pieceMenu.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pieceMenu.position = CGPoint(x: 0, y: -screenMidY+pieceMenu.frame.height/2.0)
        pieceMenu.zPosition = 10
        
        let menuHeight = pieceMenu.frame.height
        
        let customRed = SKColor(red: 243.0/255, green: 41.0/255, blue: 75.0/255, alpha: 1)
        let customYellow = SKColor(red: 255.0/255, green: 225.0/255, blue: 0, alpha: 1)
        let customGreen = SKColor(red: 87.0/255, green: 1, blue: 59.0/255, alpha: 1)
        
        createLabel("Health", position: CGPointMake(-2.6/6*screenMidX, menuHeight/5), color: customYellow,
                    horizontalAlignment: SKLabelHorizontalAlignmentMode.Left)
        
        var healthLabelColor = SKColor()
        if(currentHealth < health/4) {
            healthLabelColor = customRed
        }
        else {
            healthLabelColor = customGreen
        }
        createLabel(String(currentHealth),
                    position: CGPointMake(0.4/6*screenMidX, menuHeight/5),
                    color: healthLabelColor,
                    horizontalAlignment: SKLabelHorizontalAlignmentMode.Right)
        createLabel(String("/" + String(health)),
                    position: CGPointMake(0.4/6*screenMidX, menuHeight/5),
                    horizontalAlignment: SKLabelHorizontalAlignmentMode.Left)
        
        createLabel("Attack", position: CGPointMake(3.1/6*screenMidX, menuHeight/5), color: customYellow)
        createLabel(String(attack), position: CGPointMake(4.6/6*screenMidX, menuHeight/5))
        
        createLabel("Range", position: CGPointMake(3.1/6*screenMidX, -menuHeight/5), color: customYellow)
        createLabel(String(range), position: CGPointMake(4.6/6*screenMidX, -menuHeight/5))
        
        createLabel("Movement", position: CGPointMake(-2.6/6*screenMidX, -menuHeight/5), color: customYellow,
                    horizontalAlignment: SKLabelHorizontalAlignmentMode.Left)
        createLabel(String(range), position: CGPointMake(0.9/6*screenMidX, -menuHeight/5))
        
        createLabel("\(self.dynamicType)", position: CGPointMake(-4.2/6*screenMidX, -1.5*menuHeight/5),
                    horizontalAlignment: SKLabelHorizontalAlignmentMode.Center, fontSize: 15)
        
        let redBlue: String!
        if owner == 1 {
            redBlue = "red"
        }
        else {
            redBlue = "blue"
        }
        
        let pieceType = String(self.dynamicType).lowercaseString
        let sprite = SKSpriteNode(imageNamed: "\(pieceType) sprite " + redBlue)
        sprite.position = CGPointMake(-4.2/6*screenMidX, 0.6*menuHeight/6)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sprite.size = CGSize(width: 1.9/6*screenMidX, height: 1.9/6*screenMidX)
        pieceMenu.addChild(sprite)
        
        let cancelButton = SKSpriteNode(imageNamed: "cancel icon")
        cancelButton.position = CGPointMake(screenMidX - 8, menuHeight/2 - 8)
        cancelButton.anchorPoint = CGPointMake(1.0, 1.0)
        cancelButton.size = CGSize(width: 18, height: 18)
        cancelButton.name = "cancel button"
        pieceMenu.addChild(cancelButton)

        
    }
    
    func createLabel(text: String, position: CGPoint, color: SKColor = SKColor.whiteColor(),
                     font: String = "Avenir-Medium", fontSize: CGFloat = CGFloat(20),
                     horizontalAlignment: SKLabelHorizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center,
                     verticalAlignment: SKLabelVerticalAlignmentMode = SKLabelVerticalAlignmentMode.Baseline) {
        let label = SKLabelNode()    // displays "Health" label for health stat of unit
        label.text = text
        label.fontSize = fontSize
        label.fontName = font
        label.verticalAlignmentMode = verticalAlignment
        label.horizontalAlignmentMode = horizontalAlignment
        label.position = CGPoint(x: position.x, y: position.y - fontSize/2)
        label.fontColor = color
        pieceMenu.addChild(label)
        
    }
    
    
    // newLoc: the location of the piece in row, col
    // newPosition: the location of the piece in x, y coordinates
    func move(newLoc: (row: Int, col: Int), newPosition: CGPoint) {
        if canMove {
            self.row = newLoc.row
            self.column = newLoc.col
            self.sprite.position = newPosition
            self.sprite.alpha = 0.55
            
            canMove = false
        }
    }
    
    func attackPiece(inout target: Piece) { // inout = pass by reference
        // damage to the target
        let targetHealth = target.currentHealth - self.attack
        if(targetHealth < 0) {
            target.isAlive = false
        }
        else {
            target.currentHealth = targetHealth
        }
        
        // damage to the attacker b/c target is defending 
        // itself by attacking attacker at the same time
        let attackerHealth = self.currentHealth - target.attack
        if(self.currentHealth < 0) {
            self.isAlive = false
        }
        else {
            self.currentHealth = attackerHealth
        }
    }
    
    
}

class Warrior: Piece {      // is there a more convenient way of declaring a new piece
    init(owner: Int, row: Int, column: Int) {
        
        super.init(owner: owner, row: row, column: column, attack: 3, range: 1, health: 10, movement: 1)
        
        if(owner == 1) {
            sprite = SKSpriteNode(imageNamed: "warrior sprite red")
        }
        else if(owner == 2) {
            sprite = SKSpriteNode(imageNamed: "warrior sprite blue")
        }
    }
}

class Ranger: Piece {
    init(owner: Int, row: Int, column: Int) {
        
        super.init(owner: owner, row: row, column: column, attack: 2, range: 2, health: 8, movement: 1)
        if(owner == 1) {
            sprite = SKSpriteNode(imageNamed: "ranger sprite red")
        }
        else if(owner == 2) {
            sprite = SKSpriteNode(imageNamed: "ranger sprite blue")
        }
    }
}

class Defender: Piece {
    init(owner: Int, row: Int, column: Int) {
        
        super.init(owner: owner, row: row, column: column, attack: 1, range: 1, health: 15, movement: 1)
        if(owner == 1) {
            sprite = SKSpriteNode(imageNamed: "defender sprite red")
        }
        else if(owner == 2) {
            sprite = SKSpriteNode(imageNamed: "defender sprite blue")
        }
    }
}

class Mage: Piece {
    override init(owner: Int, row: Int, column: Int, attack: Int = 3, range: Int = 3, health: Int = 6, movement: Int = 1) {
        
        super.init(owner: owner, row: row, column: column, attack: 3, range: 3, health: 6, movement: 1)
        if(owner == 1) {
            sprite = SKSpriteNode(imageNamed: "mage sprite red")
        }
        else if(owner == 2) {
            sprite = SKSpriteNode(imageNamed: "mage sprite blue")
        }
    }
    
    // heals the target piece (arbitrarily) by 50% of its health
    func heal(target: Piece) {
        let newHealth = target.currentHealth + target.health/2
        if(newHealth > target.health) {
            target.currentHealth = target.health
        }
        else {
            target.currentHealth = newHealth
        }
    }
}


