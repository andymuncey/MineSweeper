//
//  Point.swift
//  Minesweeper
//
//  Created by Andrew Muncey on 20/04/2016.
//  Copyright © 2016 Andrew Muncey. All rights reserved.
//

import Foundation

struct Point : Equatable{
   
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
