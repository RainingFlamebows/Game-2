//
//  World.swift
//  Game-2
//
//  Created by Shannon on 4/28/16.
//  Copyright © 2016 Elena Ariza and Shannon Shih. All rights reserved.
//

import SpriteKit

class World {
    
    var board: [[Piece?]];
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
        
        base1 = Base(ownerIn: 1, rowIn: 0, colIn: numCols/2)
        base2 = Base(ownerIn: 2, rowIn: numRows - 1, colIn: numCols/2)
    }
    
    
    // figures out cell that was tapped. Returns tuple that indicates row, col of selected cell
    // in board array
    func gridTouched(gridX: CGFloat, gridY: CGFloat) -> (Int, Int)
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
            return (row, col)
        }
        else {
            print("Warning: no cell returned for gridTouched")
            return (-1, -1)
        }
    }
    
}