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
    
    func createLabel(text: String, position: CGPoint, color: SKColor = SKColor.whiteColor(), font: String = "Helvetica", fontSize: CGFloat = CGFloat(20),
        horizontalAlignment: SKLabelHorizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center) {
        let label = SKLabelNode()    // displays "Health" label for health stat of unit
        label.text = text
        label.fontSize = fontSize
        label.fontName = font
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        label.horizontalAlignmentMode = horizontalAlignment
        label.position = position
        label.fontColor = color
        statusBar.addChild(label)

    }
    
    func drawStatusBar(piece: Piece) {
        
        //        statusBar.fillColor = SKColor.redColor()
        statusBar.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        statusBar.position = CGPoint(x: 0, y: -screenMidY+statusBarHeight/2)
        statusBar.zPosition = 10
        
        createLabel("Health", position: CGPointMake(-1/3*screenMidX, statusBarHeight/4))
        
        var healthLabelColor = SKColor()
        if(piece.currentHealth < piece.health/4) {
            healthLabelColor = SKColor.redColor()
        }
        else if(piece.currentHealth < piece.health/2) {
            healthLabelColor = SKColor.yellowColor()
        }
        else {
            healthLabelColor = SKColor.greenColor()
        }
        createLabel(String(piece.currentHealth) + "/" + String(piece.health),
                    position: CGPointMake(0, statusBarHeight/4),
                    color: healthLabelColor,
                    font: "Helvetica-Bold")

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
//        healthBar.position = CGPointMake(0, statusBarHeight/4)
//        statusBar.addChild(healthBar)
        
        createLabel("Attack", position: CGPointMake(-1/3*screenMidX, -statusBarHeight/4))
//        let statusAttack = SKLabelNode()
//        statusAttack.text = "Attack"
//        statusAttack.fontSize = fontSize
//        statusAttack.fontName = font
//        statusAttack.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
//        statusAttack.position = CGPointMake(-1/3*screenMidX, -statusBarHeight/4)
//        statusBar.addChild(statusAttack)
        createLabel(String(piece.attack), position: CGPointMake(0, -statusBarHeight/4), color: SKColor.cyanColor(), font: "Helvetica-Bold")
//        let attackBar = createStatBar(piece.attack, maxHealth: maxStat, color: SKColor.cyanColor())
//        attackBar.anchorPoint = CGPointMake(0.5, 0.5)
//        attackBar.position = CGPointMake(0, -statusBarHeight/4)
//        statusBar.addChild(attackBar)
        
        createLabel("Range", position: CGPointMake(3/6*screenMidX, statusBarHeight/4 - 2.5))
        createLabel(String(piece.range), position: CGPointMake(4.5/6*screenMidX, statusBarHeight/4), color: SKColor.purpleColor(), font: "Helvetica-Bold")
        
        createLabel("Movement", position: CGPointMake(3/6*screenMidX, -statusBarHeight/4))
        createLabel(String(piece.range), position: CGPointMake(4.5/6*screenMidX, -statusBarHeight/4), color: SKColor.magentaColor(), font: "Helvetica-Bold")
        
    }


}