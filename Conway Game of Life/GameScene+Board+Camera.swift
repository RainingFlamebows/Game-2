//
//  BoardScene.swift
//  Game 2
//
//  Created by Elena Ariza on 5/23/16.
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
    }
    
    func addConstraints()
    {
        let scaledSize = CGSize(width: size.width * camera!.xScale, height: size.height * camera!.yScale)
        let boardContentRect = cellLayer.calculateAccumulatedFrame()
        let xInset = min((scaledSize.width / 2) - margin, boardContentRect.width / 2)
        let yInset = min((scaledSize.height / 2) - margin, boardContentRect.height / 2)
        
        // Use these insets to create a smaller inset rectangle within which the camera must stay.
        let insetContentRect = boardContentRect.insetBy(dx: xInset, dy: yInset)
        
        // Define an `SKRange` for each of the x and y axes to stay within the inset rectangle.
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
        
        // Constrain the camera within the inset rectangle.
        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        camera!.constraints = [levelEdgeConstraint]
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let positionInScene = touch.locationInNode(self)
        let previousPosition = touch.previousLocationInNode(self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        
        if camera?.xScale <= 1 {
            
            camera!.position = CGPoint(x: camera!.position.x - translation.x, y: camera!.position.y - translation.y)
        }
    }
    
    func pinched(sender: UIPinchGestureRecognizer) {
        
        if sender.numberOfTouches() == 2 {
            if sender.state == .Changed {
                
                zoom(sender)
            }
        }
    }

    
    func zoom(sender: UIPinchGestureRecognizer) {
        
        let locationInView = sender.locationInView(self.view)
        let location = self.convertPointFromView(locationInView)
        
        let deltaScale = (sender.scale - 1.0)*1.08
        let convertedScale = sender.scale - deltaScale
        var newScale = camera!.xScale*convertedScale
        
        if newScale < 0.24 {
            newScale = 0.25
        }
        else if newScale > 0.99 {
            newScale = 1
        }
        
        if (newScale >= 0.25 && sender.scale >= 1) ||
            (newScale <= 1 && sender.scale <= 1) {
            
            camera!.setScale(newScale)
            
            let locationAfterScale = self.convertPointFromView(locationInView)
            let locationDelta = CGPoint(x: location.x - locationAfterScale.x, y: location.y - locationAfterScale.y)
            let newPoint = CGPoint(x: camera!.position.x + locationDelta.x, y: camera!.position.y + locationDelta.y)
            camera!.position = newPoint
            
            addConstraints()
        }
        
    }


}
