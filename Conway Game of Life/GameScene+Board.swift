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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
        }
    }
    
    func tapped(sender: UITapGestureRecognizer)
    {
        let locationInView = sender.locationInView(self.view)
        let location = self.convertPointFromView(locationInView)
        
    
        if selectedMenu != nil {
            let locationInStatusBar = convertPoint(location, toNode: selectedMenu!)
            let tappedCancel = selectedMenu?.childNodeWithName("cancel button")?.containsPoint(locationInStatusBar)
            if tappedCancel == true {
                
                selectedMenu?.removeFromParent()
                selectedMenu = nil
                selectedPiece = nil
            }
        }
        else {
            
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
                    
                    selectedPiece = nil
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
                else if (selectedPiece != nil &&
                    world.availableMoves(selectedPiece!).contains({element in return (element == gridLoc)})) {
                    
                    print("move piece")
                    selectedPiece?.move(gridLoc, newPosition: CGPointMake(gridCoord[gridLoc.row][gridLoc.col].x + cellSize/2,
                        gridCoord[gridLoc.row][gridLoc.col].y - cellSize/2))
                    self.removeChildrenInArray(selectedPiece!.targets)
                }
                else if pieceAtPos != nil {
                    selectedPiece = pieceAtPos
                    // if user touched a piece
                    
                    // pull up selected piece menu
                    
                    
                    // display possible moves
                    let availableMoves = world.availableMoves(pieceAtPos!)
                    for move in availableMoves {
                        selectedPiece!.targets.append(SKSpriteNode(imageNamed: "blue target"))
                        let targetIndex = selectedPiece!.targets.count - 1
                        
                        selectedPiece!.targets[targetIndex].position = CGPointMake(gridCoord[move.row][move.col].x + cellSize/2,gridCoord[move.row][move.col].y - cellSize/2)
                        selectedPiece!.targets[targetIndex].size = CGSize(width: 0.9*cellSize, height: 0.9*cellSize)
                        selectedPiece!.targets[targetIndex].anchorPoint = CGPointMake(0.5, 0.5)

                        addChild(selectedPiece!.targets[targetIndex])
                    }
                }
                else if pieceAtPos == nil {
                    
                    selectedPiece = nil
                    selectedMenu = nil
                    
                    // hide all menus
                    world.board[gridLoc.row][gridLoc.col] = Warrior(owner: world.mode, row: gridLoc.row, column: gridLoc.col)
                    let newPiece = SKSpriteNode(imageNamed: "warrior sprite red")
                    newPiece.position = CGPointMake(gridCoord[gridLoc.row][gridLoc.col].x + cellSize/2,
                                                    gridCoord[gridLoc.row][gridLoc.col].y - cellSize/2)
                    newPiece.size = CGSize(width: 0.9*cellSize, height: 0.9*cellSize)
                    newPiece.anchorPoint = CGPointMake(0.5, 0.5)
                    world.board[gridLoc.row][gridLoc.col]?.sprite = newPiece
                    addChild(newPiece)
                }
            }
            

        }
        
        
    }
    
    
        
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
    }

}