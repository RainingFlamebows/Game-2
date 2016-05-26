//
//  GameScene.swift
//  Game-2
//
//  Created by Elena Ariza on 3/11/16.
//  Copyright (c) 2016 Elena Ariza and Shannon Shih. All rights reserved.
//

import SpriteKit

let margin: CGFloat = 20    // distance between left and right edges of grid and screen edges
let upperSpace: CGFloat = 50
let spaceBetwCells: CGFloat = 0.5

let screenMidX = UIScreen.mainScreen().bounds.width/2
let screenMidY = UIScreen.mainScreen().bounds.height/2


class GameScene: SKScene {
    
    var world: World!
    var gridCoord = [[CGPointMake(0,0)]]
    
    var cellSize: CGFloat = 0
    
    
    let cellLayer = SKNode()
    var previousScale = CGFloat(1.0)
    var sceneCam: SKCameraNode!
    
    // status screen at bottom, shows unit stats when unit selected or training queue when city is selected
    
    var selectedPiece: Piece? = nil
    var selectedMenu: SKNode? = nil
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize)
    {
        super.init(size: size)
                
        anchorPoint = CGPoint(x: 0, y: 1.0)        
                
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

        let background = SKSpriteNode(color: SKColor.blackColor(),
                                      size: CGSize(width: screenMidX*2, height: screenMidY*2))

        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sceneCam.addChild(background)
        
        addSpritesForCells(numRows, numCols: numCols)
        addChild(cellLayer)
                
        addConstraints()
        
        let pinch:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
        view.addGestureRecognizer(pinch)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tap)
    }
    
    
    
    override func update(currentTime: CFTimeInterval)
    {
        
    }
}
