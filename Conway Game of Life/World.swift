//
//  World.swift
//  Game-2
//
//  Created by Shannon on 4/28/16.
//  Copyright © 2016 Elena Ariza and Shannon Shih. All rights reserved.
//

import SpriteKit

class World {
    
    var board: [[Piece?]]
	var territory: [[Int]]

	var numRedTerritory: Int
	var numBlueTerritory: Int

    let base1: Base
    let base2: Base
 
    let numRows: Int;
    let numCols: Int;
 
    var numP1Cells: Int;
    var numP2Cells: Int;
    
    var mode: Int = 1   // player mode world is currently in: player 1 = 1, player 2 = 2
 
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
 
    /*
    * Creates an array of dead cells
    */
    init (numRowsIn: Int, numColsIn: Int)
    {
        numRows = numRowsIn;
        numCols = numColsIn;
        numP1Cells = 0;
        numP2Cells = 0;
        
        
        board = Array(count: numRows, repeatedValue: Array(count: numCols, repeatedValue: nil));
		territory = Array(count: numRows, repeatedValue: Array(count: numCols, repeatedValue: 0));
        
        numRedTerritory = 0
        numBlueTerritory = 0
        
        let totalArea = numRows*numCols
        base1 = Base(ownerIn: 1, rowIn: 0, colIn: numCols/2, numTerritory: &numRedTerritory, totalTiles: totalArea)
        base2 = Base(ownerIn: 2, rowIn: numRows - 1, colIn: numCols/2, numTerritory: &numBlueTerritory, totalTiles:totalArea)

    }
    
    
    // figures out cell that was tapped. Returns tuple that indicates row, col of selected cell
    // in board array
    func gridTouched(gridX: CGFloat, gridY: CGFloat) -> (row: Int, col: Int)
    {
        var col = 0
        var row = 0
        
        if gridX < 0 {
            col = -1
        }
        else {
            col = Int(gridX)
        }
        
        if gridY < 0 {
            row = -1
        }
        else {
            row = Int(gridY)
        }
        
        if (col >= 0 && row >= 0 &&
            col < board[0].count && row < board.count)
        {
            return (row: row, col: col)
        }
        else {
            return (row: -1, col: -1)
        }
    }
    
//    func availableTiles(thePiece: Piece) -> [(row: Int, col: Int)] {
//        var tiles = [(row: Int, col: Int)]()
//        var area = thePiece.movement
//        if area < thePiece.range {
//            area = thePiece.range
//        }
//        
//        for row in thePiece.row-area...thePiece.row+area {
//            for col in thePiece.column-area...thePiece.column+area {
//                // check if cell exists at that row, col
//                // check if there's any objects at that location
//                if(row >= 0 && row < board.count && col >= 0 && col < board[0].count) {
//                    tiles.append(row: row, col: col)
//                }
//            }
//        }
//        return tiles
//    }

    // Determines available moves for a piece by returning all unoccupied (nil) cells
    // within a thePiece.movement x thePiece.movement grid of cells around the piece.
    // returns an array of tuples representing the row and col that the available cells
    // to move to 
    func availableMoves(thePiece: Piece) -> [(row: Int, col: Int)] {
        var moves = [(row: Int, col: Int)]()
        
        for row in thePiece.row-thePiece.movement...thePiece.row+thePiece.movement {
            for col in thePiece.column-thePiece.movement...thePiece.column+thePiece.movement {
                // check if cell exists at that row, col
                // check if there's any objects at that location
                // check if there is a piece at that location
                if(row >= 0 && row < board.count && col >= 0 && col < board[0].count) {
                    if (board[row][col] == nil) {
                        moves.append(row: row, col: col)
                    }
                }
                
            }
        }
        
        return moves
    }
    
    // Determines available attacks for a piece by returning locations of all cells occupied by another Piece
    // within a thePiece.range x thePiece.range grid of cells around the piece.
    // returns an array of tuples representing the row and col that the available cells
    // to move to
    func availableAttacks(thePiece: Piece) -> [(row: Int, col: Int)] {
        var attacks = [(row: Int, col: Int)]()
        
        for row in thePiece.row-thePiece.range...thePiece.row+thePiece.range {
            for col in thePiece.column-thePiece.range...thePiece.column+thePiece.range {
                // check if cell exists at that row, col
                // check if there's any objects at that location
                // check if there is a piece at that location
                if(row >= 0 && row < board.count && col >= 0 && col < board[0].count) {
                    if (board[row][col]?.owner != nil && board[row][col]?.owner != thePiece.owner) {
                        attacks.append(row: row, col: col)
                    }
                }
                
            }
        }
        
        return attacks
    }

	func availableHeals(thePiece: Piece) -> [(row: Int, col: Int)] {
		var heals = [(row: Int, col: Int)]()

		if thePiece is Mage {
			for row in thePiece.row-thePiece.range...thePiece.row+thePiece.range {
				for col in thePiece.column-thePiece.range...thePiece.column+thePiece.range {
					// check if cell exists at that row, col
					// check if there's any objects at that location
					// check if there is a piece at that location
					if(row >= 0 && row < board.count && col >= 0 && col < board[0].count) {
						if (board[row][col]?.owner != nil && board[row][col]?.owner == thePiece.owner) {
							heals.append(row: row, col: col)
						}
					}

				}
			}
		}
		return heals
	}


	func attackPiece(attacker: Piece, target: Piece) { // inout = pass by reference
		// damage to the target
		let targetHealth = target.currentHealth - attacker.attack
		
		if(targetHealth < 0) { // target dies
			target.currentHealth = 0
			target.isAlive = false
			board[target.row][target.column] = nil
			target.sprite.removeFromParent()
		}
		else {
			target.currentHealth = targetHealth
		}

		// damage to the attacker b/c target is defending
		// itself by attacking attacker at the same time
		let attackerHealth = attacker.currentHealth - target.attack
		if(attackerHealth < 0) {
			attacker.currentHealth = 0
			attacker.isAlive = false
			board[attacker.row][attacker.column] = nil
			attacker.sprite.removeFromParent()
		}
		else {
			attacker.currentHealth = attackerHealth
		}

		attacker.sprite.alpha = 0.55
		attacker.canMove = false
	}

	func newRound() {
		for row in 0...board.count-1
		{
			for col in 0...board[0].count-1
			{
				let currentPiece = board[row][col]
				currentPiece?.sprite.alpha = 1
				currentPiece?.canMove = true
			}
		}
	}

	func updateTerritory(thePiece: Piece, territorySprites: [[SKSpriteNode]])
	{
		changeTerritory(thePiece, bounds: thePiece.movement, territorySprites: territorySprites)

		var otherPlayer = 1
		if thePiece.owner == 1 {
			otherPlayer = 2
		}
		var redBlue = "red "
		if otherPlayer == 2 {
			redBlue = "blue "
		}

		// change back territory that the opposing team is on
		let attacks = availableAttacks(thePiece)
		if attacks.count != 0 {
			for i in 0..<attacks.count {
				let prevOwner = territory[attacks[i].row][attacks[i].col]
				territory[attacks[i].row][attacks[i].col] = otherPlayer
				territorySprites[attacks[i].row][attacks[i].col].texture = SKTexture(imageNamed: redBlue + "territory")

				if otherPlayer == 1 {
					if prevOwner == 2 {
						numRedTerritory += 1
						numBlueTerritory -= 1
					}
				}
				else if otherPlayer == 2 {
					if prevOwner == 1 {
						numBlueTerritory += 1
						numRedTerritory -= 1
					}
				}
			}
		}
	}

	func changeTerritory(thePiece: Piece, bounds: Int, territorySprites: [[SKSpriteNode]])
	{
		let owner = thePiece.owner

		var redBlue = "red "
		if owner == 2 {
			redBlue = "blue "
		}

		// change all territory around the piece
		for row in thePiece.row-bounds...thePiece.row+bounds {
			for col in thePiece.column-bounds...thePiece.column+bounds {

				if(row >= 0 && row < board.count && col >= 0 && col < board[0].count) {

					let prevOwner = territory[row][col]
					territory[row][col] = owner
					territorySprites[row][col].texture = SKTexture(imageNamed: redBlue + "territory")

					if owner == 1 {
						if prevOwner == 0 {
							numRedTerritory += 1
						}
						else if prevOwner != owner {
							numRedTerritory += 1
							numBlueTerritory -= 1
						}
					}
					else {
						if prevOwner == 0 {
							numBlueTerritory += 1
						}
						else if prevOwner != owner {
							numBlueTerritory += 1
							numRedTerritory -= 1
						}
					}
				}
			}
		}
	}
}