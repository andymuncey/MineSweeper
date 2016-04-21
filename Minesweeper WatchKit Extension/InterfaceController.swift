//
//  InterfaceController.swift
//  Minesweeper WatchKit Extension
//
//  Created by Andrew Muncey on 20/04/2016.
//  Copyright © 2016 Andrew Muncey. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    //MARK: UI Components
    @IBOutlet var mineSpace0_0: WKInterfaceButton!
    @IBOutlet var mineSpace0_1: WKInterfaceButton!
    @IBOutlet var mineSpace0_2: WKInterfaceButton!
    @IBOutlet var mineSpace0_3: WKInterfaceButton!
    @IBOutlet var mineSpace0_4: WKInterfaceButton!
    
    @IBOutlet var mineSpace1_0: WKInterfaceButton!
    @IBOutlet var mineSpace1_1: WKInterfaceButton!
    @IBOutlet var mineSpace1_2: WKInterfaceButton!
    @IBOutlet var mineSpace1_3: WKInterfaceButton!
    @IBOutlet var mineSpace1_4: WKInterfaceButton!
    
    @IBOutlet var mineSpace2_0: WKInterfaceButton!
    @IBOutlet var mineSpace2_1: WKInterfaceButton!
    @IBOutlet var mineSpace2_2: WKInterfaceButton!
    @IBOutlet var mineSpace2_3: WKInterfaceButton!
    @IBOutlet var mineSpace2_4: WKInterfaceButton!
    
    @IBOutlet var mineSpace3_0: WKInterfaceButton!
    @IBOutlet var mineSpace3_1: WKInterfaceButton!
    @IBOutlet var mineSpace3_2: WKInterfaceButton!
    @IBOutlet var mineSpace3_3: WKInterfaceButton!
    @IBOutlet var mineSpace3_4: WKInterfaceButton!
    
    @IBOutlet var mineSpace4_0: WKInterfaceButton!
    @IBOutlet var mineSpace4_1: WKInterfaceButton!
    @IBOutlet var mineSpace4_2: WKInterfaceButton!
    @IBOutlet var mineSpace4_3: WKInterfaceButton!
    @IBOutlet var mineSpace4_4: WKInterfaceButton!
    
    @IBOutlet var flagButton: WKInterfaceButton!
    @IBOutlet var mineCountLabel: WKInterfaceLabel!
    
    //MARK: UI Actions
    
    @IBAction func checkMine0_0() { checkPoint(Point(x: 0, y: 0)) }
    @IBAction func checkMine0_1() { checkPoint(Point(x: 1, y: 0)) }
    @IBAction func checkMine0_2() { checkPoint(Point(x: 2, y: 0)) }
    @IBAction func checkMine0_3() { checkPoint(Point(x: 3, y: 0)) }
    @IBAction func checkMine0_4() { checkPoint(Point(x: 4, y: 0)) }
    
    @IBAction func checkMine1_0() { checkPoint(Point(x: 0, y: 1)) }
    @IBAction func checkMine1_1() { checkPoint(Point(x: 1, y: 1)) }
    @IBAction func checkMine1_2() { checkPoint(Point(x: 2, y: 1)) }
    @IBAction func checkMine1_3() { checkPoint(Point(x: 3, y: 1)) }
    @IBAction func checkMine1_4() { checkPoint(Point(x: 4, y: 1)) }
    
    @IBAction func checkMine2_0() { checkPoint(Point(x: 0, y: 2)) }
    @IBAction func checkMine2_1() { checkPoint(Point(x: 1, y: 2)) }
    @IBAction func checkMine2_2() { checkPoint(Point(x: 2, y: 2)) }
    @IBAction func checkMine2_3() { checkPoint(Point(x: 3, y: 2)) }
    @IBAction func checkMine2_4() { checkPoint(Point(x: 4, y: 2)) }
    
    @IBAction func checkMine3_0() { checkPoint(Point(x: 0, y: 3)) }
    @IBAction func checkMine3_1() { checkPoint(Point(x: 1, y: 3)) }
    @IBAction func checkMine3_2() { checkPoint(Point(x: 2, y: 3)) }
    @IBAction func checkMine3_3() { checkPoint(Point(x: 3, y: 3)) }
    @IBAction func checkMine3_4() { checkPoint(Point(x: 4, y: 3)) }
    
    @IBAction func checkMine4_0() { checkPoint(Point(x: 0, y: 4)) }
    @IBAction func checkMine4_1() { checkPoint(Point(x: 1, y: 4)) }
    @IBAction func checkMine4_2() { checkPoint(Point(x: 2, y: 4)) }
    @IBAction func checkMine4_3() { checkPoint(Point(x: 3, y: 4)) }
    @IBAction func checkMine4_4() { checkPoint(Point(x: 4, y: 4)) }
    
    @IBAction func resetPressed()
    {

        if flag {toggleFlag()}
        minefield = MineField(width: 5, height: 5)
        
        for row in possibleMines {
            for cell in row {
                cell.setTitle("")
            }
        }
        flaggedCells = [WKInterfaceButton]()
        clearedCells = [WKInterfaceButton]()
        mineCountLabel.setText("5 x")
    }
    
    @IBAction func toggleFlag() {
        if minefield.hasStarted{
            flag = !flag
            flagButton.setBackgroundColor(flag ? UIColor.redColor() : UIColor.clearColor())
        }
    }
    
    var flag = false
    var possibleMines = Array<Array<WKInterfaceButton>>()
    var minefield = MineField(width: 5, height: 5)
    var flaggedCells = [WKInterfaceButton]()
    var clearedCells = [WKInterfaceButton]()
    
    func checkPoint(point: Point){
        
        if minefield.isExploded {
            return
        }
        
        let cell = possibleMines[point.y][point.x]
        
        if !flag && flaggedCells.contains(cell){
            deFlagCell(cell)
            return
        }
        
        if flag && !clearedCells.contains(cell) {
            flagCell(cell)
            checkForCompletion()
            return
        }
        
        let status = minefield.checkMine(point)
        if status.isMine {
            showAllMines()
            WKInterfaceDevice().playHaptic(.Failure)
            return
        }
        
        cell.setTitle("\(status.adjacentMineCount)")
        clearedCells.append(cell)
        checkForCompletion()
    }
    
    func checkForCompletion(){
        if clearedCells.count + flaggedCells.count == 25 {
            mineCountLabel.setText("👍")
            WKInterfaceDevice().playHaptic(.Success)
        }
    }
    
    func showAllMines(){
        for minePoint in minefield.mineLocations() {
            possibleMines[minePoint.y][minePoint.x].setTitle("💣")
            mineCountLabel.setText("0 x")
        }
    }
    
    func deFlagCell(cell: WKInterfaceButton){
        //clearing a flag from a cell
        cell.setTitle("")
        flaggedCells.removeAtIndex(flaggedCells.indexOf(cell)!)
        updateMineCountLabel()
    }
    
    func flagCell(cell: WKInterfaceButton){
        if !flaggedCells.contains(cell){
            cell.setTitle("🇰🇵")
            flaggedCells.append(cell)
            updateMineCountLabel()
        }
    }
    
    func updateMineCountLabel(){
        let estimatedMinesLeft = minefield.mineCount - flaggedCells.count
        mineCountLabel.setText("\(estimatedMinesLeft) x")
    }
    
    override func willActivate() {
        
        for _ in 0..<5{
            possibleMines.append([WKInterfaceButton]())
        }
        
        //add mines to array
        possibleMines[0].append(mineSpace0_0)
        possibleMines[0].append(mineSpace0_1)
        possibleMines[0].append(mineSpace0_2)
        possibleMines[0].append(mineSpace0_3)
        possibleMines[0].append(mineSpace0_4)
        
        possibleMines[1].append(mineSpace1_0)
        possibleMines[1].append(mineSpace1_1)
        possibleMines[1].append(mineSpace1_2)
        possibleMines[1].append(mineSpace1_3)
        possibleMines[1].append(mineSpace1_4)
        
        possibleMines[2].append(mineSpace2_0)
        possibleMines[2].append(mineSpace2_1)
        possibleMines[2].append(mineSpace2_2)
        possibleMines[2].append(mineSpace2_3)
        possibleMines[2].append(mineSpace2_4)
        
        possibleMines[3].append(mineSpace3_0)
        possibleMines[3].append(mineSpace3_1)
        possibleMines[3].append(mineSpace3_2)
        possibleMines[3].append(mineSpace3_3)
        possibleMines[3].append(mineSpace3_4)
        
        possibleMines[4].append(mineSpace4_0)
        possibleMines[4].append(mineSpace4_1)
        possibleMines[4].append(mineSpace4_2)
        possibleMines[4].append(mineSpace4_3)
        possibleMines[4].append(mineSpace4_4)
        
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
}