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
            
            let pinch:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(GameScene.pinched(_:)))
            view!.addGestureRecognizer(pinch)
            
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.tapped(_:)))
            view!.addGestureRecognizer(tap)
        }
    }
    
    func tapped(sender: UITapGestureRecognizer)
    {
        let locationInView = sender.locationInView(self.view)
        let location = self.convertPointFromView(locationInView)
        let locationInStatusBar = convertPoint(location, toNode: statusBar)
        
    
        if statusBar.childNodeWithName("cancel button")!.containsPoint(locationInStatusBar) {
            statusBar.removeFromParent()
        }
        else {
            
            let gridX = (location.x - margin) / (cellSize + spaceBetwCells)
            let gridY = (abs(location.y) - upperSpace) / (cellSize + spaceBetwCells)
            
            let gridLoc = world.gridTouched(gridX, gridY: gridY)
            
            if (gridLoc.0 >= 0 && gridLoc.1 >= 0 &&
                gridLoc.0 < world.numRows && gridLoc.1 < world.numCols)
            {
                let pieceAtPos = world.board[gridLoc.0][gridLoc.1]
                
                if gridLoc == (world.base1.row, world.base1.col) && world.mode == 1 ||
                    gridLoc == (world.base2.row, world.base2.col) && world.mode == 2 {
                    
                    if world.mode == 1 {
                        addBaseMenu(world.base1)
                    }
                    else {
                        addBaseMenu(world.base2)
                    }
                }
                else if pieceAtPos != nil {
                    selectedPiece = pieceAtPos
                    
                    // pull up selected piece menu
                }
                else if pieceAtPos == nil {
                    
                    // hide all menus
                }
            }

        }
        
        
        
        
        
        //        let newPiece = SKSpriteNode(imageNamed: "warrior sprite red")
        //        newPiece.position = CGPointMake(gridCoord[gridLoc.0][gridLoc.1].x + cellSize/2,
        //                                        gridCoord[gridLoc.0][gridLoc.1].y - cellSize/2)
        //
        //        newPiece.size = CGSize(width: 0.9*cellSize, height: 0.9*cellSize)
        //        newPiece.anchorPoint = CGPointMake(0.5, 0.5)
        //        addChild(newPiece)
        
    }
    
    
    func addBaseMenu(base: Base)
    {
        // queue/piece menu
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