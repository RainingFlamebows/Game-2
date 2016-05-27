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
                
                //                var cell = SKSpriteNode()
                //                cell = SKSpriteNode(imageNamed: "dead")
                //                cell.size = CGSize(width: cellSize, height: cellSize)
                //                cell.position = CGPointMake(leftCornerCell, -upperCornerCell)
                //                cell.anchorPoint = CGPoint(x: 0, y: 1.0)
                //                cell.alpha = 0.6
                //
                //                cellLayer.addChild(cell)
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
        var tappedCancel = false
        
        if selectedMenu != nil {
            let locationInStatusBar = convertPoint(location, toNode: selectedMenu!)
            tappedCancel = selectedMenu?.childNodeWithName("cancel button")?.containsPoint(locationInStatusBar) ?? false
            if tappedCancel == true {
                
                hideSelectedMenu()
                if selectedPiece != nil {
                    removeChildrenInArray(selectedPiece!.targets)
                }
                selectedPiece = nil
            }
        }
        
        if !tappedCancel {
            let gridX = (location.x - margin) / (cellSize + spaceBetwCells)
            let gridY = (abs(location.y) - upperSpace) / (cellSize + spaceBetwCells)
            
            let gridLoc = world.gridTouched(gridX, gridY: gridY)
            
            if (gridLoc.row >= 0 && gridLoc.col >= 0 &&
                gridLoc.row < world.numRows && gridLoc.col < world.numCols)
            {
                let pieceAtPos = world.board[gridLoc.row][gridLoc.col]
                
                // touched either base
                if gridLoc == (world.base1.row, world.base1.col) && world.mode == 1 ||
                    gridLoc == (world.base2.row, world.base2.col) && world.mode == 2 {
                    
                    if selectedPiece != nil {
                        removeChildrenInArray(selectedPiece!.targets)
                    }
                    selectedPiece = nil

                    hideSelectedMenu()
                    
                    let baseMenu1 = world.base1.baseMenu
                    let baseMenu2 = world.base2.baseMenu
                    
                    if world.mode == 1 && baseMenu1.parent == nil {
                        selectedMenu = baseMenu1
                        sceneCam.addChild(baseMenu1)
                        print("touched base 1")
                    }
                    else if world.mode == 2 && baseMenu2.parent == nil{
                        selectedMenu = baseMenu2
                        sceneCam.addChild(baseMenu2)
                        print("touched base 2")
                    }
                }
                    // move piece
                else if (selectedPiece != nil && selectedPiece!.canMove && selectedPiece?.owner == world.mode) {
                    
                    // tapped one of the targets
                    // move selectedPiece
                    if(world.availableMoves(selectedPiece!).contains({element in return (element == gridLoc)})) {
                        print("move piece")
                        world.board[selectedPiece!.row][selectedPiece!.column] = nil
                        
                        selectedPiece?.move(gridLoc, newPosition: CGPointMake(gridCoord[gridLoc.row][gridLoc.col].x + cellSize/2,
                            gridCoord[gridLoc.row][gridLoc.col].y - cellSize/2))
                        
                        let newRow = selectedPiece!.row
                        let newCol = selectedPiece!.column
                        
                        world.board[newRow][newCol] = selectedPiece
                    }
                    else if(world.availableAttacks(selectedPiece!).contains({element in return (element == gridLoc)})) {
//                        selectedPiece?.attack(&pieceAtPos)    // this gives errors. I'm so confused. There's no Int in here
                    }
                    
                    self.removeChildrenInArray(selectedPiece!.targets)
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
                    
                    if selectedPiece!.canMove {
                        // display possible moves
                        let availableTiles = world.availableTiles(pieceAtPos!)
                        
                        selectedPiece!.targets.removeAll()
                        for move in availableTiles {
                            
                            let pieceAtTile = world.board[move.row][move.col]
                            var newSprite: SKSpriteNode? = nil
                            
                            if pieceAtTile == nil {
                                // available move
                                newSprite = SKSpriteNode(imageNamed: "blue target")
                            }
                            else if pieceAtTile?.owner != selectedPiece?.owner {
                                // attack this piece
                                newSprite = SKSpriteNode(imageNamed: "red glow") // this will not show up correctly bc attack uses range and not movement stat
                            }
                            
                            
                            if newSprite != nil {
                                newSprite!.position = CGPointMake(gridCoord[move.row][move.col].x + cellSize/2,gridCoord[move.row][move.col].y - cellSize/2)
                                newSprite!.size = CGSize(width: 0.9*cellSize, height: 0.9*cellSize)
                                newSprite!.anchorPoint = CGPointMake(0.5, 0.5)
                                addChild(newSprite!)
                                
                                selectedPiece!.targets.append(newSprite!)
                            }
                        }
                        
                        
                        // displays available attack options
                        let availableAttacks = world.availableAttacks(pieceAtPos!)
                        for attack in availableAttacks {
                            let pieceAtTile = world.board[attack.row][attack.col]
                            var newSprite: SKSpriteNode? = nil
                            
                            if pieceAtTile?.owner != selectedPiece?.owner {
                                // attack this piece
                                newSprite = SKSpriteNode(imageNamed: "red glow")
                            }
                            
                            
                            if newSprite != nil {
                                newSprite!.position = CGPointMake(gridCoord[attack.row][attack.col].x + cellSize/2,gridCoord[attack.row][attack.col].y - cellSize/2)
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
                else if pieceAtPos == nil && selectedPiece == nil {
                    
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
                else if pieceAtPos == nil && selectedPiece != nil {
                    removeChildrenInArray(selectedPiece!.targets)
                    selectedPiece = nil
                    hideSelectedMenu()
                }
            }
            
        }
        
        
        
    }
    
    func hideSelectedMenu() {
        selectedMenu?.removeFromParent()
        selectedMenu = nil
    }
    

}