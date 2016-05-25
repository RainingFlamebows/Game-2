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
    let spaceBetwCells: CGFloat = 0.5
    var cellSize: CGFloat = 0
    
    var screenMidX: CGFloat!
    var screenMidY: CGFloat!
    
    let cellLayer = SKNode()
    var previousScale = CGFloat(1.0)
    var sceneCam: SKCameraNode!
    
    // status screen at bottom, shows unit stats when unit selected or training queue when city is selected
    var statusBar = SKSpriteNode() // <- when graphics finished make this SKSpriteNode
    var statusBarHeight = CGFloat(100)
    
    
    var selectedPiece: Piece? = nil
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize)
    {
        super.init(size: size)
        
        screenMidX = CGRectGetMidX(frame)
        screenMidY = CGRectGetMidY(frame)
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        statusBar = SKSpriteNode(color: SKColor.lightGrayColor(), size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: statusBarHeight))
//        statusBar = SKShapeNode(path: CGPathCreateWithRect(
//            CGRectMake(screenMidX, 0, UIScreen.mainScreen().bounds.size.width, 140), nil), centered: true)
        
    }
    
        
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let numRows = 20
        let numCols = 11
        world = World(numRowsIn: numRows, numColsIn: numCols)
        
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
        
        drawStatusBar(Warrior(owner: 1, row: 1, column: 1))

        sceneCam.addChild(statusBar)
        
        addConstraints()
    }
    
        
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
        
        // figures out whether cell is touched
        let locationInView = sender.locationInView(self.view)
        let location = self.convertPointFromView(locationInView)

        let gridX = (location.x - margin) / (cellSize + spaceBetwCells)
        let gridY = (abs(location.y) - upperSpace) / (cellSize + spaceBetwCells)
        
        let newPiece = SKSpriteNode(imageNamed: "warrior sprite red")
        let gridLoc = world.gridTouched(gridX, gridY: gridY)
        
        print(gridLoc)
        
        if (gridLoc.0 >= 0 && gridLoc.1 >= 0 &&
            gridLoc.0 < world.numRows && gridLoc.1 < world.numCols)
        {
            newPiece.position = CGPointMake(gridCoord[gridLoc.0][gridLoc.1].x + cellSize/2,
                                            gridCoord[gridLoc.0][gridLoc.1].y - cellSize/2)
            
            newPiece.size = CGSize(width: 0.9*cellSize, height: 0.9*cellSize)
            newPiece.anchorPoint = CGPointMake(0.5, 0.5)
            addChild(newPiece)
        }

    }
    
    override func update(currentTime: CFTimeInterval)
    {
        
    }
}
