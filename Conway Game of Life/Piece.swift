//
//  File.swift
//  Game 2
//
//  Created by Elena Ariza on 5/13/16.
//  Copyright © 2016 Elena Ariza and Shannon Shih. All rights reserved.
//

import Foundation
import SpriteKit

class Piece {
    var row: Int
    var column: Int
    var attack: Int
    var defense: Double // <- do we still need defense?
    var range: Int
    var health: Int
    var currentHealth: Int
    var movement: Int
    
    var isAlive: Bool
    var owner: Int // player 1 = 1, player 2 = 2
    
    var sprite: SKSpriteNode!
    
    init(owner: Int, row: Int, column: Int, attack: Int, defense: Double, range: Int, health: Int, movement: Int) {
        self.owner = owner
        self.row = row
        self.column = column
        self.attack = attack
        self.defense = defense
        self.range = range
        self.health = health
        self.movement = movement
        self.isAlive = true
        
        currentHealth = self.health // piece has max HP by default
    }
    
    func attack(target: Piece) {
        let newHealth = target.currentHealth - self.attack
        if(newHealth < 0) {
            target.isAlive = false
        }
        else {
            target.currentHealth = newHealth
        }
    }
    
    // gives a list of available cells piece can move into while 
    // taking into account the location of other pieces and objects
    // then returns a list of potential places piece can move to
    // and potential places piece can attack
    func availableMoves() {
        var moves = [()]
        var attacks = [()]
        for row in column-range...column+range {
            for col in row-range...row+range {
                // check if cell exists at that row, col
                // check if there's any objects at that location
                // if there is a piece at that location
            }
        }
    }
}

class Warrior: Piece {
    override init(owner: Int, row: Int, column: Int, attack: Int, defense: Double, range: Int, health: Int, movement: Int) {
        
        super.init(owner: owner, row: row, column: column, attack: 3, defense: 2, range: 1, health: 10, movement: 1)
        if(owner == 1) {
            sprite = SKSpriteNode(imageNamed: "warrior sprite red")
        }
        else if(owner == 2) {
            sprite = SKSpriteNode(imageNamed: "warrior sprite blue")
        }
    }
}

class Ranger: Piece {
    override init(owner: Int, row: Int, column: Int, attack: Int, defense: Double, range: Int, health: Int, movement: Int) {
        
        super.init(owner: owner, row: row, column: column, attack: 2, defense: 2, range: 2, health: 8, movement: 1)
        if(owner == 1) {
            sprite = SKSpriteNode(imageNamed: "ranger sprite red")
        }
        else if(owner == 2) {
            sprite = SKSpriteNode(imageNamed: "ranger sprite blue")
        }
    }
}

class Defender: Piece {
    override init(owner: Int, row: Int, column: Int, attack: Int, defense: Double, range: Int, health: Int, movement: Int) {
        
        super.init(owner: owner, row: row, column: column, attack: 1, defense: 5, range: 1, health: 15, movement: 1)
        if(owner == 1) {
            sprite = SKSpriteNode(imageNamed: "defender sprite red")
        }
        else if(owner == 2) {
            sprite = SKSpriteNode(imageNamed: "defender sprite blue")
        }
    }
}

class Mage: Piece {
    override init(owner: Int, row: Int, column: Int, attack: Int, defense: Double, range: Int, health: Int, movement: Int) {
        
        super.init(owner: owner, row: row, column: column, attack: 3, defense: 2, range: 3, health: 6, movement: 1)
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


