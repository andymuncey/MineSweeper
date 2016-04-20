//
//  Minesweeper.swift
//  Minesweeper
//
//  Created by Andrew Muncey on 20/04/2016.
//  Copyright © 2016 Andrew Muncey. All rights reserved.
//

import Foundation

class Point : Equatable{
    
    var x: Int
    var y: Int
    
    init(x: Int, y: Int){
        self.x = x
        self.y = y
    }
}

func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

struct MineInfo {
    var isMine = false
    var adjacentMineCount = 0
}

class MineField {
    
    var hasStarted = false
    var isExploded = false
    var mineCount = 0
    var field = Array<Array<MineInfo>>()
    
    var width: Int
    var height: Int
    
    init(width: Int, height: Int){
        
        self.width = width
        self.height = height
        
        for _ in 0..<height {
            //create row
            var row = [MineInfo]()
            for _ in 0..<width {
                row.append(MineInfo())
            }
            field.append(row)
        }
    }
    
    
    func checkMine(point: Point) -> MineInfo{
        if !hasStarted{
            hasStarted = true
            determineMinesWithStartPoint(point)
        }
        
        let location = field[point.y][point.x]
        if location.isMine {
            isExploded = true
        }
        var mineInfo = MineInfo()
        mineInfo.adjacentMineCount = location.adjacentMineCount
        mineInfo.isMine = location.isMine
        return mineInfo
    }
    
    
    func determineMinesWithStartPoint(point: Point){
       
        mineCount = Int(sqrt(Double(width * height)))
        populateMines(mineCount, avoidingPoint: point)
        populateAdjacentMineCount()
    }
    
    func populateMines(count: Int, avoidingPoint startPoint: Point){
        var mineLocations = [Point]()
        repeat {
            let randPoint = getRandomPoint(width, height: height)
            if startPoint != randPoint && !mineLocations.contains(randPoint){
                mineLocations.append(randPoint)
            }
        } while mineLocations.count < count
        
        for point in mineLocations {
            field[point.y][point.x].isMine = true
        }
        
    }
    
    func mineLocations() -> [Point] {
        var mines = [Point]()
        for y in 0..<field.count {
            for x in 0..<field[y].count{
                if field[y][x].isMine {
                    mines.append(Point(x: x, y: y))
                }
            }
        }
        return mines
    }
    
    func validNeighboursForPoint(point: Point) -> [Point] {
        
        var neighbours = [Point]()
        let minX = max(0,point.x - 1)
        let maxX = min(width-1,point.x + 1)
        let minY = max(0, point.y-1)
        let maxY = min(height-1,point.y+1)
        
        for x in minX...maxX {
            for y in minY...maxY {
                if !(point.x == x && point.y == y) {
                    neighbours.append(Point(x: x, y: y))
                }
            }
        }
        return neighbours
    }
    
    func countMinesAtPoints(points: [Point]) -> Int{
        
        var count = 0
        for point in points {
            if field[point.y][point.x].isMine{
                count += 1
            }
        }
        return count
    }
    
    func populateAdjacentMineCount(){
        
        for y in 0..<field.count {
            for x in 0..<field[y].count{
                
                let neighbours = validNeighboursForPoint(Point(x: x, y: y))
                let nearbyMines = countMinesAtPoints(neighbours)
                field[y][x].adjacentMineCount = nearbyMines
            }
        }
        
    }
    
    func getRandomPoint(width: Int, height: Int) -> Point{
        let x = Int(arc4random_uniform(UInt32(width)))
        let y = Int(arc4random_uniform(UInt32(height)))
        return Point(x: x, y: y)
    }
}


