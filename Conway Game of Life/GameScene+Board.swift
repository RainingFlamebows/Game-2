//
//  GameScene+Board.swift
//  Game 2
//
//  Created by Elena Ariza on 5/24/16.
//  Copyright © 2016 Elena Ariza and Shannon Shih. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func addSpritesForCells(numRows: Int, numCols: Int)
    {
        gridCoord = Array(count: numRows, repeatedValue: Array(count: numCols, repeatedValue: CGPointMake(0,0)))
        
        let bounds = UIScreen.mainScreen().bounds
        let widthScreen = bounds.size.width
        
        let gridWidth: CGFloat = widthScreen - margin*2
        
        let image = UIImage(named: "11x20 background")
        let sizeBackground = image?.size
        
        let gameBoard = SKSpriteNode(imageNamed: "11x20 background")
        gameBoard.size = CGSize(width: gridWidth, height: sizeBackground!.height*gridWidth/(sizeBackground!.width))
        gameBoard.anchorPoint = CGPointMake(0, 1.0)
        gameBoard.position = CGPointMake(margin, -upperSpace)
        gameBoard.alpha = 1
        cellLayer.addChild(gameBoard)
        
		cellSize = (gridWidth - spaceBetwCells - CGFloat(numCols-1)*spaceBetwCells) * 1.0 / CGFloat(numCols)
        
        for row in 0...numRows-1 {
            for col in 0...numCols-1 {
                
                let leftCornerCell = margin + CGFloat(col) * (cellSize + spaceBetwCells) + spaceBetwCells*0.5
                let upperCornerCell = upperSpace + CGFloat(row) * (cellSize + spaceBetwCells) + spaceBetwCells*0.5
                gridCoord[row][col] = CGPointMake(leftCornerCell, -upperCornerCell)
                
//                                var cell = SKSpriteNode()
//                                cell = SKSpriteNode(imageNamed: "red territory")
//                                cell.size = CGSize(width: cellSize, height: cellSize)
//                                cell.position = CGPointMake(leftCornerCell, -upperCornerCell)
//                                cell.anchorPoint = CGPoint(x: 0, y: 1.0)
//                                cell.alpha = 0.6
//                
//                                cellLayer.addChild(cell)
            }
        }
        
        // create bases
        drawBases(world.base1)
        drawBases(world.base2)
        
    }
    
    func drawBases(theBase: Base) {
        let baseSprite = theBase.baseSprite
        baseSprite.position = CGPointMake(gridCoord[theBase.row][theBase.col].x + cellSize/2,gridCoord[theBase.row][theBase.col].y - cellSize/2)
        baseSprite.size = CGSize(width: 0.9*cellSize, height: 0.9*cellSize)
        baseSprite.anchorPoint = CGPointMake(0.5, 0.5)
        cellLayer.addChild(baseSprite)
    }

   
    
    func tapped(sender: UITapGestureRecognizer)
    {

        let locationInView = sender.locationInView(self.view)
        let location = self.convertPointFromView(locationInView)

		let locInCamera = convertPoint(location, toNode: camera!)

		let gridX = (location.x - margin) / (cellSize + spaceBetwCells)
		let gridY = (abs(location.y) - upperSpace) / (cellSize + spaceBetwCells)
		let gridLoc = world.gridTouched(gridX, gridY: gridY)

		if selectedMenu?.containsPoint(locInCamera) ?? false {
			let locationInStatusBar = convertPoint(location, toNode: selectedMenu!)
			let tappedCancel = selectedMenu!.childNodeWithName("cancel button")?.containsPoint(locationInStatusBar)

			let tappedInMenu = selectedMenu!.containsPoint(locInCamera)

			if tappedCancel == true {
				hideSelectedMenu()
			}
			else if tappedInMenu == false {
				hideSelectedMenu()
				if selectedPiece != nil {
					removeChildrenInArray(selectedPiece!.targets)
				}
				selectedPiece = nil
			}
			else if (world.mode == 1 && selectedMenu == world.base1.baseMenu) {
				touchedInsideBase(world.base1, locationInStatusBar: locationInStatusBar)
			}
			else if (world.mode == 2 && selectedMenu == world.base2.baseMenu) {
				touchedInsideBase(world.base2, locationInStatusBar: locationInStatusBar)
			}

		}
		else if nextRoundButton.containsPoint(locInCamera)
		{
			if world.mode == 1 {
				world.mode = 2
				world.base2.nextRound(world.numBlueTerritory, totalTerritory: world.totalArea)
                playerGlow.texture = SKTexture(imageNamed: "blue player glow")
			}
			else {
				world.mode = 1
				world.base1.nextRound(world.numRedTerritory, totalTerritory: world.totalArea
                )
                playerGlow.texture = SKTexture(imageNamed: "red player glow")
			}
			world.newRound()
			selectedMenu?.removeFromParent()
			if selectedPiece != nil {
				removeChildrenInArray(selectedPiece!.targets)
			}
			selectedPiece = nil
		}
		else if (gridLoc.row >= 0 && gridLoc.col >= 0 &&
			gridLoc.row < world.numRows && gridLoc.col < world.numCols)
		{
			let pieceAtPos = world.board[gridLoc.row][gridLoc.col]

			// touched either base
			if (gridLoc == (world.base1.row, world.base1.col) || gridLoc == (world.base2.row, world.base2.col)) &&
            selectedPiece == nil{

				if selectedPiece != nil {
					removeChildrenInArray(selectedPiece!.targets)
				}
				selectedPiece = nil

				hideSelectedMenu()

				let baseMenu1 = world.base1.baseMenu
				let baseMenu2 = world.base2.baseMenu

				if world.mode == 1 && baseMenu1.parent == nil {
                    if gridLoc == (world.base1.row, world.base1.col) {
                        selectedMenu = baseMenu1
                        sceneCam.addChild(baseMenu1)
                    }
                    else {    // if tapped enemy's base, show that base's miniBaseMenu
                        selectedMenu = world.base2.miniBaseMenu
                        sceneCam.addChild(selectedMenu!)
                    }
				}
				else if world.mode == 2 && baseMenu2.parent == nil {
                    if gridLoc == (world.base2.row, world.base2.col) {
                        selectedMenu = baseMenu2
                        sceneCam.addChild(baseMenu2)
                    }
                    else {
                        selectedMenu = world.base1.miniBaseMenu
                        sceneCam.addChild(selectedMenu!)
                    }
				}
			}
			else if selectedPiece != nil && selectedPiece!.canMove && selectedPiece!.owner == world.mode &&
					(world.availableMoves(selectedPiece!).contains({element in return (element == gridLoc)}) ||
					world.availableAttacks(selectedPiece!).contains({element in return (element == gridLoc)}) ||
					world.availableHeals(selectedPiece!).contains({element in return (element == gridLoc)})) {

				// tapped one of the targets
				// move selectedPiece
				if(world.availableMoves(selectedPiece!).contains({element in return (element == gridLoc)})) {
					world.board[selectedPiece!.row][selectedPiece!.column] = nil

					selectedPiece?.move(gridLoc, newPosition: CGPointMake(gridCoord[gridLoc.row][gridLoc.col].x + cellSize/2,
						gridCoord[gridLoc.row][gridLoc.col].y - cellSize/2))
					runAction(SKAction.waitForDuration(0.2))

					let newRow = selectedPiece!.row
					let newCol = selectedPiece!.column

					world.board[newRow][newCol] = selectedPiece
				}
				else if(world.availableAttacks(selectedPiece!).contains({element in return (element == gridLoc)})) {

                    if((world.base1.row, world.base1.col) == gridLoc && world.base1.owner != selectedPiece!.owner) {

                        world.attackBase(selectedPiece!, target: world.base1)
						animateAttackBase(world.base1)
                        //***** need to updates status bar for base
                        world.base1.updateBaseMenu()
                        // ***** animate attacking base?
                    }
                    else if ((world.base2.row, world.base2.col) == gridLoc && world.base2.owner != selectedPiece!.owner) {

                        world.attackBase(selectedPiece!, target: world.base2)
						animateAttackBase(world.base2)
                        world.base2.updateBaseMenu()
                        //***** need to updates status bar for base
                        //**** animate attacking base?
                    }
                    else {
                        let prevAttackerHealth = selectedPiece!.currentHealth

						world.attackPiece(selectedPiece!, target: pieceAtPos!)

                        if prevAttackerHealth == selectedPiece!.currentHealth {
							animateAttack(pieceAtPos!)
							runAction(SKAction.waitForDuration(0.4))
                            animateHealthLabel(pieceAtPos!, healthLost: selectedPiece!.attack)
                        }
                        else {
                            animateAttack(selectedPiece!, target: pieceAtPos!)
							runAction(SKAction.waitForDuration(0.4))
                            animateHealthLabel(selectedPiece!, healthLost: pieceAtPos!.attack)
                            animateHealthLabel(pieceAtPos!, healthLost: selectedPiece!.attack)
                        }

                        selectedPiece!.updateStatusBar()
                        pieceAtPos!.updateStatusBar()
                    }
				}
				else if world.availableHeals(selectedPiece!).contains({element in return (element == gridLoc)}) {

					let prevHealth = pieceAtPos!.currentHealth
					(selectedPiece! as! Mage).heal(pieceAtPos!)
					animateHeal(pieceAtPos!, healthGained: pieceAtPos!.currentHealth - prevHealth)

					selectedPiece!.updateStatusBar()
					pieceAtPos!.updateStatusBar()
				}

				self.removeChildrenInArray(selectedPiece!.targets)
				world.updateTerritory(selectedPiece!, territorySprites: territorySprites)
				selectedPiece = nil
				hideSelectedMenu()
			}
			else if pieceAtPos != nil && selectedPiece != pieceAtPos {
				// if user touched a piece, but not the same piece as before

				if selectedPiece != nil {
					removeChildrenInArray(selectedPiece!.targets)
				}
				selectedPiece = pieceAtPos

				// pull up selected piece menu

				selectedMenu?.removeFromParent()
				selectedMenu = selectedPiece!.pieceMenu
				sceneCam.addChild(selectedMenu!)

				if selectedPiece!.canMove && selectedPiece!.owner == world.mode {
					// display possible moves
					let availableMoves = world.availableMoves(pieceAtPos!)

					selectedPiece!.targets.removeAll()
					for move in availableMoves {

						var newSprite: SKSpriteNode? = nil

						newSprite = SKSpriteNode(imageNamed: "blue target")

						newSprite!.position = CGPointMake(gridCoord[move.row][move.col].x + cellSize/2,gridCoord[move.row][move.col].y - cellSize/2)
						newSprite!.size = CGSize(width: 0.9*cellSize, height: 0.9*cellSize)
						newSprite!.anchorPoint = CGPointMake(0.5, 0.5)

						addChild(newSprite!)

						selectedPiece!.targets.append(newSprite!)
					}


					// displays available attack options
					let availableAttacks = world.availableAttacks(pieceAtPos!)
					for attack in availableAttacks {

						var newSprite: SKSpriteNode? = nil

						newSprite = SKSpriteNode(imageNamed: "red target")

						newSprite!.position = CGPointMake(gridCoord[attack.row][attack.col].x + cellSize/2,gridCoord[attack.row][attack.col].y - cellSize/2)
						newSprite!.size = CGSize(width: 0.9*cellSize, height: 0.9*cellSize)
						newSprite!.anchorPoint = CGPointMake(0.5, 0.5)
						addChild(newSprite!)

						selectedPiece!.targets.append(newSprite!)
					}

					if pieceAtPos is Mage {
						let availableHeals = world.availableHeals(pieceAtPos!)
						for heal in availableHeals {
							var newSprite: SKSpriteNode? = nil

							newSprite = SKSpriteNode(imageNamed: "green target")

							newSprite!.position = CGPointMake(gridCoord[heal.row][heal.col].x + cellSize/2,gridCoord[heal.row][heal.col].y - cellSize/2)
							newSprite!.size = CGSize(width: 0.9*cellSize, height: 0.9*cellSize)
							newSprite!.anchorPoint = CGPointMake(0.5, 0.5)
							addChild(newSprite!)

							selectedPiece!.targets.append(newSprite!)
						}
					}

				}
			}
			else if pieceAtPos != nil && selectedPiece == pieceAtPos && selectedMenu == nil {
				selectedMenu = selectedPiece!.pieceMenu
				sceneCam.addChild(selectedMenu!)
			}
			else if pieceAtPos == nil && selectedPiece != nil && selectedMenu == nil {
				if selectedPiece != nil {
					removeChildrenInArray(selectedPiece!.targets)
					selectedPiece = nil
				}
				hideSelectedMenu()
			}
			else if pieceAtPos == nil && selectedMenu == nil &&
                gridLoc != (world.base1.row, world.base1.col) &&
                gridLoc != (world.base2.row, world.base2.col) {

				if selectedPiece != nil {
					removeChildrenInArray(selectedPiece!.targets)
				}
				hideSelectedMenu()
				selectedPiece = nil

				world.board[gridLoc.row][gridLoc.col] = Warrior(owner: world.mode, row: gridLoc.row, column: gridLoc.col)
				let newPiece = world.board[gridLoc.row][gridLoc.col]!.sprite
				newPiece.position = CGPointMake(gridCoord[gridLoc.row][gridLoc.col].x + cellSize/2,
				                                gridCoord[gridLoc.row][gridLoc.col].y - cellSize/2)
				newPiece.size = CGSize(width: 0.9*cellSize, height: 0.9*cellSize)
				newPiece.anchorPoint = CGPointMake(0.5, 0.5)
				world.board[gridLoc.row][gridLoc.col]?.sprite = newPiece
				addChild(newPiece)
			}
			else if pieceAtPos == nil && selectedMenu != nil {
				if selectedPiece != nil {
					removeChildrenInArray(selectedPiece!.targets)
					selectedPiece = nil
				}
				hideSelectedMenu()
			}

		}


        addConstraints()
		print("red territory: \(world.numRedTerritory)")
		print("blue territory: \(world.numBlueTerritory)")

    }

    func hideSelectedMenu() {
        selectedMenu?.removeFromParent()
        selectedMenu = nil
    }

	func touchedInsideBase(base: Base, locationInStatusBar: CGPoint)
	{
		for piece in base.pieces {
			if(piece.containsPoint(locationInStatusBar)) {
				var availableQueue = base.getAvailableQueue()
				if(availableQueue != nil && availableQueue?.canChange == true) {
					//                    availableQueue!.innerSprite.texture = piece.texture
					availableQueue!.addPieceToQueue(piece)
				}
				else {
					print("no more spaces left in queue")
				}
				availableQueue = nil
				break // no point in iterating thru rest of queue if location where user touched queue already identified
			}
		}

		for q in base.trainingQueue {

			if q.innerSprite.containsPoint(locationInStatusBar) && q.statusLabel.text == "ready!" {
				// user touched piece in trainingQueue for which training has finished
				// add this piece onto board

				print("touched ready piece")
				q.thePiece?.row = base.row
				q.thePiece?.column = base.col

				world.board[base.row][base.col] = q.thePiece
				let newPiece = world.board[base.row][base.col]!.sprite
				newPiece.position = CGPointMake(gridCoord[base.row][base.col].x + cellSize/2,
				                                gridCoord[base.row][base.col].y - cellSize/2)
				newPiece.size = CGSize(width: 0.9*cellSize, height: 0.9*cellSize)
				newPiece.anchorPoint = CGPointMake(0.5, 0.5)
				world.board[base.row][base.col]?.sprite = newPiece
				addChild(newPiece)

				q.canChange = true
				q.innerSprite.removeFromParent()
				q.thePiece = nil



				break
			}
		}
	}


	func animateHealthLabel(thePiece: Piece, healthLost: Int) {

		let spritePos = thePiece.sprite.position
		let label = SKLabelNode()
		label.text = String("- \(healthLost)")
		label.fontSize = 15
		label.fontName = "Avenir-Black"
		label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
		label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
		label.position = spritePos
		label.fontColor = SKColor.redColor()

		let moveAction = SKAction.moveTo(CGPointMake(spritePos.x, spritePos.y + 10), duration: NSTimeInterval(2))
		moveAction.timingMode = .EaseOut

		addChild(label)

		label.runAction(SKAction.sequence([SKAction.group([moveAction, SKAction.fadeOutWithDuration(NSTimeInterval(2))]),
				SKAction.removeFromParent()]))
	}

	func animateHeal(thePiece: Piece, healthGained: Int) {

		let spritePos = thePiece.sprite.position
		let label = SKLabelNode()
		label.text = String("+ \(healthGained)")
		label.fontSize = 15
		label.fontName = "Avenir-Black"
		label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
		label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
		label.position = spritePos
		label.fontColor = SKColor.greenColor()

		let moveAction = SKAction.moveTo(CGPointMake(spritePos.x, spritePos.y + 10), duration: NSTimeInterval(2))
		moveAction.timingMode = .EaseOut

		addChild(label)

		label.runAction(SKAction.sequence([SKAction.group([moveAction, SKAction.fadeOutWithDuration(NSTimeInterval(2))]),
			SKAction.removeFromParent()]))
	}

	func animateAttack(thePiece: Piece, target: Piece) {
		let spritePos = thePiece.sprite.position
		let targetSpritePos = target.sprite.position

		let oppositePoint = CGPoint(x: 2*spritePos.x - targetSpritePos.x, y: 2*spritePos.y - targetSpritePos.y)
		let oppositePointAttacker = CGPoint(x: 2*targetSpritePos.x - spritePos.x, y: 2*targetSpritePos.y - spritePos.y)
		let launchAction = [SKAction.moveTo(dividePoint(spritePos, to: targetSpritePos, factor: 4), duration: NSTimeInterval(0.1)),
		                    SKAction.moveTo(dividePoint(spritePos, to: oppositePoint, factor: 4), duration: NSTimeInterval(0.1)),
		                    SKAction.moveTo(dividePoint(spritePos, to: targetSpritePos, factor: 8), duration: NSTimeInterval(0.1)),
		                    SKAction.moveTo(dividePoint(spritePos, to: oppositePoint, factor: 8), duration: NSTimeInterval(0.1)),
		                    SKAction.moveTo(spritePos, duration: NSTimeInterval(0.1))]

		let moveAction = [SKAction.moveTo(dividePoint(targetSpritePos, to: spritePos, factor: 4), duration: NSTimeInterval(0.1)),
						  SKAction.moveTo(dividePoint(targetSpritePos, to: oppositePointAttacker, factor: 4), duration: NSTimeInterval(0.1)),
						  SKAction.moveTo(dividePoint(targetSpritePos, to: spritePos, factor: 8), duration: NSTimeInterval(0.1)),
						  SKAction.moveTo(dividePoint(targetSpritePos, to: oppositePointAttacker, factor: 8), duration: NSTimeInterval(0.1)),
		                  SKAction.moveTo(targetSpritePos, duration: NSTimeInterval(0.1))]

		thePiece.sprite.runAction(SKAction.sequence(launchAction))
		target.sprite.runAction(SKAction.sequence(moveAction))
	}

	func animateAttack(target: Piece) {
		let targetSpritePos = target.sprite.position

		let moveAction = [SKAction.moveTo(CGPointMake(targetSpritePos.x + 5, targetSpritePos.y), duration: NSTimeInterval(0.1)),
		                  SKAction.moveTo(CGPointMake(targetSpritePos.x - 5, targetSpritePos.y), duration: NSTimeInterval(0.1)),
		                  SKAction.moveTo(CGPointMake(targetSpritePos.x + 2, targetSpritePos.y), duration: NSTimeInterval(0.1)),
		                  SKAction.moveTo(CGPointMake(targetSpritePos.x - 2, targetSpritePos.y), duration: NSTimeInterval(0.1)),
		                  SKAction.moveTo(targetSpritePos, duration: NSTimeInterval(0.1))]
		target.sprite.runAction(SKAction.sequence(moveAction))
	}

	func animateAttackBase(base: Base) {
		let baseSpritePos = base.baseSprite.position

		let moveAction = [SKAction.moveTo(CGPointMake(baseSpritePos.x + 5, baseSpritePos.y), duration: NSTimeInterval(0.1)),
		                  SKAction.moveTo(CGPointMake(baseSpritePos.x - 5, baseSpritePos.y), duration: NSTimeInterval(0.1)),
		                  SKAction.moveTo(CGPointMake(baseSpritePos.x + 2, baseSpritePos.y), duration: NSTimeInterval(0.1)),
		                  SKAction.moveTo(CGPointMake(baseSpritePos.x - 2, baseSpritePos.y), duration: NSTimeInterval(0.1)),
		                  SKAction.moveTo(baseSpritePos, duration: NSTimeInterval(0.1))]
		base.baseSprite.runAction(SKAction.sequence(moveAction))

	}

	func dividePoint(from: CGPoint, to: CGPoint, factor: CGFloat) -> CGPoint
	{
		let xCoord = (to.x - from.x)/factor + from.x
		let yCoord = (to.y - from.y)/factor + from.y

		return CGPoint(x: xCoord, y: yCoord)
	}

}