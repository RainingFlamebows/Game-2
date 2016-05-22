//
//  GameScene.swift
//  Game-2
//
//  Created by Elena Ariza on 3/11/16.
//  Copyright (c) 2016 Elena Ariza and Shannon Shih. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var world: World!
    var gridCoord = [[CGPointMake(0,0)]]
    
    let margin: CGFloat = 20    // distance between left and right edges of grid and screen edges
    let upperSpace: CGFloat = 50
    let spaceBetwCells: CGFloat = 1.4
    var cellSize: CGFloat = 0
    
    var screenMidX: CGFloat!
    var screenMidY: CGFloat!
    
    let cellLayer = SKNode()
    var previousScale = CGFloat(1.0)
    var sceneCam: SKCameraNode!
    
    // status screen at bottom, shows unit stats when unit selected or training queue when city is selected
    var statusBar = SKShapeNode() // <- when graphics finished make this SKSpriteNode
    var statusHealth = SKLabelNode()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize)
    {
        super.init(size: size)
        
        screenMidX = CGRectGetMidX(frame)
        screenMidY = CGRectGetMidY(frame)
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        statusBar = SKShapeNode(path: CGPathCreateWithRect(
            CGRectMake(screenMidX, -screenMidY,UIScreen.mainScreen().bounds.size.width, 125), nil), centered: true)
    }
    
    // creates a health bar using two rectangles whose widths correspond to amount of current health and amount of max health
    // color: the color the currentHealth part of the health bar should be
    func createHealthBar(currentHealth: Int, maxHealth: Int, color: SKColor) {
        // can you pass SKNodes without dying?
        var maxHealthRect = SKShapeNode(path: CGPathCreateWithRect(CGRectMake(screenMidX, -screenMidY, 30, 15), nil), centered: true)
        var currentHealthRect = SKShapeNode(path: CGPathCreateWithRect(CGRectMake(screenMidX, -screenMidY, 30-(30*CGFloat(currentHealth/maxHealth)), 15), nil), centered: true)
        maxHealthRect.fillColor = SKColor.darkGrayColor()
        currentHealthRect.fillColor = color
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let numRows = 30
        let numCols = 20
        
        sceneCam = SKCameraNode()
        sceneCam.setScale(1)
        sceneCam.position = CGPoint(x: frame.midX, y: frame.midY)
        camera = sceneCam
        
        addChild(sceneCam)

        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sceneCam.addChild(background)

        
        addSpritesForCells(numRows, numCols: numCols)
        addChild(cellLayer)
        
        statusBar.fillColor = SKColor.redColor()
        statusBar.position = CGPoint(x: 0, y: -UIScreen.mainScreen().bounds.size.height/2+25)
        
        statusHealth.text = "Health"
        statusHealth.fontSize = 15
        statusHealth.fontName = "HelveticaBold"
        statusHealth.position = CGPointMake(0, 0)
        statusBar.addChild(statusHealth)
        statusBar.zPosition = 100
        
        sceneCam.addChild(statusBar)
    }
    
    func addSpritesForCells(numRows: Int, numCols: Int)
    {
        gridCoord = Array(count: numRows, repeatedValue: Array(count: numCols, repeatedValue: CGPointMake(0,0)))
        
        let bounds = UIScreen.mainScreen().bounds
        let widthScreen = bounds.size.width
        
        let gridWidth: CGFloat = widthScreen - margin*2
        cellSize = (gridWidth - CGFloat(numCols-1)*spaceBetwCells) * 1.0 / CGFloat(numCols)
        
        for row in 0...numRows-1 {
            for col in 0...numCols-1 {
                
                let leftCornerCell = margin + CGFloat(col) * (cellSize + spaceBetwCells)
                let upperCornerCell = upperSpace + CGFloat(row) * (cellSize + spaceBetwCells)
                gridCoord[row][col] = CGPointMake(leftCornerCell, -upperCornerCell)
                
                var cell = SKSpriteNode()
                cell = SKSpriteNode(imageNamed: "dead")
                cell.size = CGSize(width: cellSize, height: cellSize)
                cell.position = CGPointMake(leftCornerCell, -upperCornerCell)
                cell.anchorPoint = CGPoint(x: 0, y: 1.0)
                
                
                cellLayer.addChild(cell)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {

//            let location = touch.locationInNode(self)
            
            
            let pinch:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(GameScene.pinched(_:)))
            view!.addGestureRecognizer(pinch)
            
            // figures out whether cell is touched
            let location = touch.locationInNode(self)
            let gridX = (location.x - margin) / (cellSize + spaceBetwCells)
            let gridY = (abs(location.y) - upperSpace) / (cellSize + spaceBetwCells)
            
            //attempt to make cells turn dark grey when tapped by user (to let user know which cell they're selecting)
//            let tappedCell = world.gridTouched(gridX, gridY: gridY)
//            world.board[tappedCell.0][tappedCell.1].updateState(SELECTED)
            
            
        }
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
        
        let deltaScale = (sender.scale - 1.0)*2
        let convertedScale = sender.scale - deltaScale
        let newScale = camera!.xScale*convertedScale
        
        if (newScale >= 0.25 && sender.scale > previousScale) ||
            (newScale <= 1 && sender.scale < previousScale) {

            print("\(camera?.xScale), \(newScale), \(convertedScale)")
            camera!.setScale(newScale)
        
            let locationInView = sender.locationInView(self.view)
            let location = self.convertPointFromView(locationInView)
            
            let locationAfterScale = self.convertPointFromView(locationInView)
            let locationDelta = CGPoint(x: location.x - locationAfterScale.x, y: location.y - locationAfterScale.y)
            let newPoint = CGPoint(x: camera!.position.x - locationDelta.x, y: camera!.position.y - locationDelta.y)
            camera!.position = newPoint
            
            
            
        }
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        
    }
}
