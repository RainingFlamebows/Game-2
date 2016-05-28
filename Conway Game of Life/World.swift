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
    func gridTouched(gridX: CGFloat, gridY: CGFloat) -> (row: Int, col: Int)
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
            return (row: row, col: col)
        }
        else {
            print("Warning: no cell returned for gridTouched")
            return (row: -1, col: -1)
        }
    }
    
    func availableTiles(thePiece: Piece) -> [(row: Int, col: Int)] {
        var tiles = [(row: Int, col: Int)]()
        var area = thePiece.movement
        if area < thePiece.range {
            area = thePiece.range
        }
        
        for row in thePiece.row-area...thePiece.row+area {
            for col in thePiece.column-area...thePiece.column+area {
                // check if cell exists at that row, col
                // check if there's any objects at that location
                if(row >= 0 && row < board.count && col >= 0 && col < board[0].count) {
                    tiles.append(row: row, col: col)
                }
            }
        }
        return tiles
    }
    
    // Determines available moves for a piece by returning all unoccupied (nil) cells
    // within a thePiece.movement x thePiece.movement grid of cells around the piece.
    // returns an array of tuples representing the row and col that the available cells
    // to move to 
    func availableMoves(thePiece: Piece) -> [(row: Int, col: Int)] {
        var moves = [(row: Int, col: Int)]()
        
        for row in thePiece.row-thePiece.movement...thePiece.row+thePiece.movement {
            for col in thePiece.column-thePiece.movement...thePiece.column+thePiece.movement {
                // check if cell exists at that row, col
                // check if there's any objects at that location
                // check if there is a piece at that location
                if(row >= 0 && row < board.count && col >= 0 && col < board[0].count) {
                    if (board[row][col] == nil) {
                        moves.append(row: row, col: col)
                    }
                }
                
            }
        }
        
        return moves
    }
    
    // Determines available attacks for a piece by returning locations of all cells occupied by another Piece
    // within a thePiece.range x thePiece.range grid of cells around the piece.
    // returns an array of tuples representing the row and col that the available cells
    // to move to
    func availableAttacks(thePiece: Piece) -> [(row: Int, col: Int)] {
        var attacks = [(row: Int, col: Int)]()
        
        for row in thePiece.row-thePiece.range...thePiece.row+thePiece.range {
            for col in thePiece.column-thePiece.range...thePiece.column+thePiece.range {
                // check if cell exists at that row, col
                // check if there's any objects at that location
                // check if there is a piece at that location
                if(row >= 0 && row < board.count && col >= 0 && col < board[0].count) {
                    if (board[row][col]?.owner != nil && board[row][col]?.owner != thePiece.owner) {
                        attacks.append(row: row, col: col)
                    }
                }
                
            }
        }
        
        return attacks
    }
}