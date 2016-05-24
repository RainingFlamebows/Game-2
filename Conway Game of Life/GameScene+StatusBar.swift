//
//  GameScene+StatusBar.swift
//  Game 2
//
//  Created by Elena Ariza on 5/23/16.
//  Copyright © 2016 Elena Ariza and Shannon Shih. All rights reserved.
//

import Foundation

import SpriteKit

extension GameScene {
    
    // creates a health bar using two rectangles whose widths correspond to amount of current health and amount of max health
    // color: the color the currentHealth part of the health bar should be
    // health bar width is randomly set to 30. Make width global variable or add to argument of function?
    //
    func createStatBar(currentHealth: Int, maxHealth: Int, color: SKColor) -> SKSpriteNode {
        
        let margin = CGFloat(2.5) // thickness of border between outer maxHealthRect and currentHealthRect
        let statBarWidth = CGFloat(60)
        let statBarHeight = CGFloat(15)
        
        let statBar = SKSpriteNode()
        let maxHealthRect = SKSpriteNode(color: SKColor.blackColor(), size: CGSize(width: statBarWidth, height: statBarHeight))
        maxHealthRect.anchorPoint = CGPointMake(0.5,0.5)
        
        let currentHealthWidth = statBarWidth*CGFloat(currentHealth)/CGFloat(maxHealth) - margin*2
        let currentHealthRect = SKSpriteNode(color: color, size: CGSize(width: currentHealthWidth, height: statBarHeight - margin*2))
        
        currentHealthRect.anchorPoint = CGPoint(x: 0, y: 0)
        currentHealthRect.position = CGPointMake(-statBarWidth/2 + margin, -statBarHeight/2 + margin)
        //        currentHealthRect.position = CGPointMake(-currentHealthWidth/2 + margin, 0)
        
        maxHealthRect.addChild(currentHealthRect)
        statBar.addChild(maxHealthRect)
        
        return statBar
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
        statusBar.addChild(label)

    }
    
    func drawStatusBar(piece: Piece) {
        
        
        //        statusBar.fillColor = SKColor.redColor()
        statusBar.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        statusBar.position = CGPoint(x: 0, y: -screenMidY+statusBarHeight/2)
        statusBar.zPosition = 10
        
        let customRed = SKColor(red: 243.0/255, green: 41.0/255, blue: 75.0/255, alpha: 1)
        let customYellow = SKColor(red: 255.0/255, green: 225.0/255, blue: 0, alpha: 1)
        let customGreen = SKColor(red: 87.0/255, green: 1, blue: 59.0/255, alpha: 1)

        createLabel("Health", position: CGPointMake(-2.5/6*screenMidX, statusBarHeight/5), color: customYellow,
                    horizontalAlignment: SKLabelHorizontalAlignmentMode.Left)
        
        var healthLabelColor = SKColor()
        if(piece.currentHealth < piece.health/4) {
            healthLabelColor = customRed
        }
        else {
            healthLabelColor = customGreen
        }
        createLabel(String(piece.currentHealth),
                    position: CGPointMake(0.5/6*screenMidX, statusBarHeight/5),
                    color: healthLabelColor,
                    horizontalAlignment: SKLabelHorizontalAlignmentMode.Right)
        createLabel(String("/" + String(piece.health)),
                    position: CGPointMake(0.5/6*screenMidX, statusBarHeight/5),
                    horizontalAlignment: SKLabelHorizontalAlignmentMode.Left)

//        var healthLabelColor = SKColor()
//        // determines color of health bar:
//        // green by default, yellow if currentHP < 50%, red if currentHP < 25% of max HP
//        if(piece.currentHealth < piece.health/4) {
//            healthLabelColor = SKColor.redColor()
//        }
//        else if(piece.currentHealth < piece.health/2) {
//            healthLabelColor = SKColor.yellowColor()
//        }
//        else {
//            healthLabelColor = SKColor.greenColor()
//        }
//        
//        let healthBar = createStatBar(piece.currentHealth, maxHealth: piece.health, color: healthLabelColor)
//        healthBar.anchorPoint = CGPointMake(0.5,0.5)
//        healthBar.position = CGPointMake(0, statusBarHeight/5)
//        statusBar.addChild(healthBar)
//        
//        let statusAttack = SKLabelNode()
//        statusAttack.text = "Attack"
//        statusAttack.fontSize = fontSize
//        statusAttack.fontName = font
//        statusAttack.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
//        statusAttack.position = CGPointMake(-1/3*screenMidX, -statusBarHeight/5)
//        statusBar.addChild(statusAttack)
//
//        let attackBar = createStatBar(piece.attack, maxHealth: maxStat, color: SKColor.cyanColor())
//        attackBar.anchorPoint = CGPointMake(0.5, 0.5)
//        attackBar.position = CGPointMake(0, -statusBarHeight/5)
//        statusBar.addChild(attackBar)
        
        createLabel("Attack", position: CGPointMake(3.5/6*screenMidX, statusBarHeight/5), color: customYellow)
        createLabel(String(piece.attack), position: CGPointMake(5/6*screenMidX, statusBarHeight/5))
        
        createLabel("Range", position: CGPointMake(3.5/6*screenMidX, -statusBarHeight/5), color: customYellow)
        createLabel(String(piece.range), position: CGPointMake(5/6*screenMidX, -statusBarHeight/5))
        
        createLabel("Movement", position: CGPointMake(-2.5/6*screenMidX, -statusBarHeight/5), color: customYellow,
                    horizontalAlignment: SKLabelHorizontalAlignmentMode.Left)
        createLabel(String(piece.range), position: CGPointMake(1/6*screenMidX, -statusBarHeight/5))
        
        createLabel("\(piece.dynamicType)", position: CGPointMake(-4.25/6*screenMidX, -statusBarHeight/4),
                    color: customYellow, horizontalAlignment: SKLabelHorizontalAlignmentMode.Center, fontSize: 15)

        let redBlue: String!
        if piece.owner == 1 {
            redBlue = "red"
        }
        else {
            redBlue = "blue"
        }
        
        let pieceType = String(piece.dynamicType).lowercaseString
        let sprite = SKSpriteNode(imageNamed: "\(pieceType) sprite " + redBlue)
        sprite.position = CGPointMake(-4.25/6*screenMidX, statusBarHeight/5)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sprite.size = CGSize(width: 1.5/6*screenMidX, height: 1.5/6*screenMidX)
        statusBar.addChild(sprite)
    }


}