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
    
    func drawStatusBar(piece: Piece) {
        
        let maxStat = 10        // the maximum number any stat (except health) can be among all pieces
        let fontSize = CGFloat(20)
        let font = "HelveticaBold"
        //        statusBar.fillColor = SKColor.redColor()
        statusBar.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        statusBar.position = CGPoint(x: 0, y: -screenMidY+statusBarHeight/2)
        
        let statusHealth = SKLabelNode()    // displays "Health" label for health stat of unit
        statusHealth.text = "Health"
        statusHealth.fontSize = fontSize
        statusHealth.fontName = font
        statusHealth.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        statusHealth.position = CGPointMake(-1/3*screenMidX, statusBarHeight/4)
        statusBar.addChild(statusHealth)
        statusBar.zPosition = 10
        
        var healthBarColor = SKColor()
        // determines color of health bar:
        // green by default, yellow if currentHP < 50%, red if currentHP < 25% of max HP
        if(piece.currentHealth < piece.health/4) {
            healthBarColor = SKColor.redColor()
        }
        else if(piece.currentHealth < piece.health/2) {
            healthBarColor = SKColor.yellowColor()
        }
        else {
            healthBarColor = SKColor.greenColor()
        }
        
        let healthBar = createStatBar(piece.currentHealth, maxHealth: piece.health, color: healthBarColor)
        healthBar.anchorPoint = CGPointMake(0.5,0.5)
        healthBar.position = CGPointMake(0, statusBarHeight/4)
        statusBar.addChild(healthBar)
        
        
        let statusAttack = SKLabelNode()
        statusAttack.text = "Attack"
        statusAttack.fontSize = fontSize
        statusAttack.fontName = font
        statusAttack.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        statusAttack.position = CGPointMake(-1/3*screenMidX, -statusBarHeight/4)
        statusBar.addChild(statusAttack)
        
        let attackBar = createStatBar(piece.attack, maxHealth: maxStat, color: SKColor.cyanColor())
        attackBar.anchorPoint = CGPointMake(0.5, 0.5)
        attackBar.position = CGPointMake(0, -statusBarHeight/4)
        statusBar.addChild(attackBar)
        
        let statusRange = SKLabelNode()
        statusRange.text = "Range"
        
        
    }


}