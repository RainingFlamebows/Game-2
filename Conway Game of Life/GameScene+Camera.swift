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
    
    func addConstraints()
    {
        let scaledSize = CGSize(width: size.width * camera!.xScale, height: size.height * camera!.yScale)
        let boardContentRect = cellLayer.calculateAccumulatedFrame()
        let menuHeight = (selectedMenu?.frame.height ?? 0) * camera!.yScale
        let xInset = min((scaledSize.width / 2) - margin, boardContentRect.width / 2)
        let yInset = min((scaledSize.height / 2) - margin, boardContentRect.height / 2)
        
        // Use these insets to create a smaller inset rectangle within which the camera must stay.
        let insetContentRect = boardContentRect.insetBy(dx: xInset, dy: yInset)
        
        // Define an `SKRange` for each of the x and y axes to stay within the inset rectangle.
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY - menuHeight, upperLimit: insetContentRect.maxY)
        
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
        
        let deltaScale = (sender.scale - 1.0)*2
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
            sender.scale = 1
        }
        
    }

}
