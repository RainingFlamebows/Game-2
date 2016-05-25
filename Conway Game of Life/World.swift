//
//  World.swift
//  Game-2
//
//  Created by Shannon on 4/28/16.
//  Copyright © 2016 Elena Ariza and Shannon Shih. All rights reserved.
//

import SpriteKit

class World {
    var board: [[Cell]];
 
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
        
        board = Array(count: numRows, repeatedValue: Array(count: numCols, repeatedValue: Cell(xIn: 0, yIn: 0)));

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
    
    /*
    * Counts number of cells owned by player 1 and 2 that are neighboring
    * a certain cell and returns result as a tuple
    * x: x coordinate of the cell
    * y: y coordinate of the cell
    */
    func countNeighbors(x: Int, y: Int) -> (Int, Int) {
        var count = (0,0);
        
        // subtract center cell from total count
        if(board[x][y].state == 1) {count.0 -= 1}
        else if(board[x][y].state == 2) {count.1 -= 1}
        
        for row in x-1..<x+1 {
            for col in y-1..<y+1 {
                if(row >= 0 && row < board.count && col >= 0 && col < board[0].count) {
                    let neighborCellState = board[row][col].state
                    if(neighborCellState == 1) {count.0 += 1}
                    else if(neighborCellState == 2) {count.1 += 1}
                }
            }
        }
        print(count)
        
        return count
    }
}