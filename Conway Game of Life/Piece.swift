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
    var attack: Double
    var defense: Double
    var range: Int
    var health: Int
    var movement: Int
    
    var sprite: SKSpriteNode!
    
    init(row: Int, column: Int, attack: Double, defense: Double, range: Int, health: Int, movement: Int) {
        self.row = row
        self.column = column
        self.attack = attack
        self.defense = defense
        self.range = range
        self.health = health
        self.movement = movement
    }
}

class Warrior: Piece {
    override init(row: Int, column: Int, attack: Double, defense: Double, range: Int, health: Int, movement: Int) {
        
        super.init(row: row, column: column, attack: 3, defense: 2, range: 1, health: 10, movement: 1)
        sprite = SKSpriteNode(imageNamed: "sprite warrior v1")
    }
}

class Ranger: Piece {
    override init(row: Int, column: Int, attack: Double, defense: Double, range: Int, health: Int, movement: Int) {
        
        super.init(row: row, column: column, attack: 2, defense: 2, range: 2, health: 8, movement: 1)
        sprite = SKSpriteNode(imageNamed: "sprite ranger v1")
    }
}

class Defender: Piece {
    override init(row: Int, column: Int, attack: Double, defense: Double, range: Int, health: Int, movement: Int) {
        
        super.init(row: row, column: column, attack: 1, defense: 5, range: 1, health: 15, movement: 1)
        sprite = SKSpriteNode(imageNamed: "sprite defender v1")
    }
}

class Mage: Piece {
    override init(row: Int, column: Int, attack: Double, defense: Double, range: Int, health: Int, movement: Int) {
        
        super.init(row: row, column: column, attack: 3, defense: 2, range: 3, health: 6, movement: 1)
        sprite = SKSpriteNode(imageNamed: "sprite mage v1")
    }
}


