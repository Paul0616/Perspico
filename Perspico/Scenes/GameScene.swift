//
//  GameScene.swift
//  Perspico
//
//  Created by Paul Oprea on 24/07/2019.
//  Copyright © 2019 Paul Oprea. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    let colors = [UIColor.yellow , UIColor.red , UIColor.purple, UIColor.green, UIColor.brown, UIColor.orange]
    let colorNames = ["yellow", "red", "purple", "green", "brown", "orange"]
    var colorPickNodes: [SKShapeNode] = []
    var currentPlayerNodes: [SKShapeNode] = []
    var movableColor: SKShapeNode!
    var currentRow: Int = 0
    var currentRandomColors: [UIColor] = []
   // var boardHorizontalLines:[SKShapeNode]!
    override func didMove(to view: SKView) {
       currentRandomColors = randomColors(number: pinNumber, colors: colors)
       layoutScene()
    }
    
    func layoutScene(){
        createGameBoard()
        createPickColorsSection()
        
//        for row in 0..<rounds {
//            for position in 0..<pinNumber{
//                createResponse(row: row, position: position, correctPosition: true)
//            }
//
//            let randomCol = randomColors(number: pinNumber, colors: colors)
            for position in 0..<pinNumber{
                createPlayerPins(row: 5, position: position, color: currentRandomColors[position])
            }
//        }
        currentPlayerNodes.removeAll()
        for position in 0..<pinNumber{
            if let obj = createPlayerPins(row: currentRow, position: position, color: UIColor.clear) {
                currentPlayerNodes.append(obj)
            }
        }
    }
    
    func createGameBoard(){
        //create outter rectangle
        let rowSize = getRowSize()
        let boardsize = getBoardSize()
        let board = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: boardsize), cornerRadius: CGFloat(offset))
        board.position = CGPoint(x: offset, y: offset)
        board.lineWidth = 2.0
        board.strokeColor = UIColor.white
        addChild(board)
        
        //create inner lines and row labels
        for n in 1...rounds {
            if n < rounds {
                let pathToDraw = CGMutablePath()
                let line = SKShapeNode()
                pathToDraw.move(to: CGPoint(x: offset, y: offset + CGFloat(n) * rowSize.height))
                pathToDraw.addLine(to: CGPoint(x: offset + board.frame.size.width - 2*line.lineWidth, y: offset + CGFloat(n) * rowSize.height))
                line.path = pathToDraw
                line.strokeColor = SKColor.white
                addChild(line)
            }
            let label = SKLabelNode(text: "\(rounds-n+1)")
            label.position = CGPoint(x: offset*2.5, y: offset + CGFloat(n) * rowSize.height - rowSize.height/2 - label.frame.size.height/2)
            addChild(label)
        }
        //create vertical line
        let pathToDraw = CGMutablePath()
        let verticalLine = SKShapeNode()
        pathToDraw.move(to: CGPoint(x: offset + rowSize.height, y: offset))
        pathToDraw.addLine(to: CGPoint(x: offset + rowSize.height, y: offset + board.frame.size.height - 2*verticalLine.lineWidth))
        verticalLine.path = pathToDraw
        verticalLine.strokeColor = SKColor.white
        addChild(verticalLine)
    }
    
    func createPickColorsSection(){
        let rowSize = getRowSize()
        var index = 0
        for color in colors{
            let pickCircle = SKShapeNode(circleOfRadius: getPlayerCircleRadius(rowSize: rowSize))
            pickCircle.strokeColor = UIColor.clear
            pickCircle.fillColor = color
            let i = 2*index + 1
            let x = offset + CGFloat(i)*(rowSize.width/CGFloat(colors.count)/2)
            let y = offset + CGFloat(rounds) * rowSize.height + rowSize.height/2
            pickCircle.position = CGPoint(x: x, y: y)
            pickCircle.name = colorNames[index]
            colorPickNodes.append(pickCircle)
            addChild(pickCircle)
            index += 1
        }
    }
    
    
    func createPlayerPins(row: Int, position: Int, color: UIColor)->SKShapeNode!{
        //row = 0 => (rounds-1-row) => 6-1-0 = 5
        //row = 1 => (rounds-1-row) => 6-1-1 = 4
        //..
        //row = 5 => (rounds-1-row) => 6-1-5 = 0
        
        if position > pinNumber-1 {
            print("Position must be in 0...\(pinNumber)")
            return nil
        }
        let rowSize = getRowSize()
        let playerCircle = SKShapeNode(circleOfRadius: getPlayerCircleRadius(rowSize: rowSize))
        let pinBoardWidth = (rowSize.width - rowSize.height)/CGFloat(pinNumber)/2
        let i = 2*position + 1
        let x = offset + rowSize.height + CGFloat(i)*pinBoardWidth
        let y = offset + CGFloat(rounds-row-1) * rowSize.height + rowSize.height/2
        playerCircle.position = CGPoint(x: x, y: y)
        if color == UIColor.clear{
            playerCircle.fillColor = color
            playerCircle.strokeColor = UIColor.white
        } else {
            playerCircle.fillColor = color
            playerCircle.strokeColor = UIColor.clear
        }
        addChild(playerCircle)
        return playerCircle
    }
    
    
    func createResponse(row: Int, position: Int, correctPosition: Bool){
        if pinNumber != 4 {
            print("Pins must be equal with...\(pinNumber)")
            return
        } else {
            let rowSize = getRowSize()
            let responseCircle = SKShapeNode(circleOfRadius: getPlayerCircleRadius(rowSize: rowSize)/2)
            let k = position/2*2 + 1
            responseCircle.position = CGPoint(x: 2*offset + CGFloat(position%2+1)*rowSize.height/3, y: offset + CGFloat(rounds-row-1) * rowSize.height + CGFloat(k)*rowSize.height/4)
            responseCircle.strokeColor = UIColor.clear
            if correctPosition {
                responseCircle.fillColor = UIColor.black
            } else {
                responseCircle.fillColor = UIColor.white
            }
            addChild(responseCircle)
        }
        
    }
    
    func getPlayerCircleRadius(rowSize: CGSize)->CGFloat{
        return (rowSize.width - rowSize.height)/(CGFloat(pinNumber)*2 + 2)
    }
    
    func getRowSize()->CGSize{
        let boardSize = getBoardSize()
        let size = CGSize(width: boardSize.width, height: boardSize.height/CGFloat(rounds))
        return size
    }
    
    func getBoardSize()->CGSize{
        let boardSize = CGSize(width: frame.size.width - offset*2, height: frame.size.height - offset*2 - frame.size.height/CGFloat(rounds+1))
        return boardSize
    }
    
    func randomColors(number: Int, colors: [UIColor]) -> [UIColor] {
        guard number > 0 else { return [UIColor]() }
        var remaining = colors
        var chosen = [UIColor]()
        for _ in 0 ..< number {
            guard !remaining.isEmpty else { break }
            let randomIndex = Int(arc4random_uniform(UInt32(remaining.count)))
            chosen.append(remaining[randomIndex])
            remaining.remove(at: randomIndex)
        }
        return chosen
    }
    
    func checkCurrentNodesIsFilled() -> Bool{
        if currentPlayerNodes.count == 0 {
            return false
        }
        for node in currentPlayerNodes{
            if node.strokeColor == UIColor(red: 1, green: 1, blue: 1, alpha: 1) {
                return false
            }
        }
        return true
    }
 
    func nextRound(){
        currentRow += 1
        currentPlayerNodes.removeAll()
        for position in 0..<pinNumber{
            if let obj = createPlayerPins(row: currentRow, position: position, color: UIColor.clear) {
                currentPlayerNodes.append(obj)
            }
        }
    }
    
    func getResponse(){
        var whites = 0
        var blacks = 0
        var i = 0
        var j = 0
        for nodePlayer in currentPlayerNodes {
            for nodeRandom in currentRandomColors {
                if nodePlayer.fillColor == nodeRandom {
                    if i == j {
                       blacks += 1
                    } else {
                        whites += 1
                    }
                }
                j += 1
            }
            j = 0
            i += 1
            
        }
        for position in 0..<whites{
            createResponse(row: currentRow, position: position, correctPosition: false)
        }
        for position in 0..<blacks{
            createResponse(row: currentRow, position: position, correctPosition: true)
        }
        print("\(whites) - \(blacks)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            for node in colorPickNodes{
                if node.contains(location) {
                    if let n = node.copy() as? SKShapeNode{
                        movableColor = n
                        movableColor!.position = location
                        addChild(movableColor)
                    }
                    
                }
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            movableColor = nil
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableColor != nil {
            movableColor!.position = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableColor != nil {
            for node in currentPlayerNodes {
                if node.contains(touch.location(in: self)){
                    node.strokeColor = UIColor.clear
                    node.fillColor = movableColor.fillColor
                    break
                }
            }
            movableColor!.position = touch.location(in: self)
            movableColor.removeFromParent()
            movableColor = nil
            
            if checkCurrentNodesIsFilled() {
                getResponse()
                nextRound()
            }
        }
    }

//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
}
