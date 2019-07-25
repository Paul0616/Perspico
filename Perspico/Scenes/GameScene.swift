//
//  GameScene.swift
//  Perspico
//
//  Created by Paul Oprea on 24/07/2019.
//  Copyright © 2019 Paul Oprea. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    
   // var boardHorizontalLines:[SKShapeNode]!
    override func didMove(to view: SKView) {
       layoutScene()
       
    }
    
    func layoutScene(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        let rowSize = getRowSize()
        let boardsize = getBoardSize()
        
        let board = SKShapeNode(rect: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: boardsize))//(rect: CGRect(x: 0, y: 0, width: frame.size.width - offset*2, height: frame.size.height - offset*2))
        board.position = CGPoint(x: offset, y: offset)
        board.lineWidth = 2.0
        addChild(board)
        for n in 1...rounds-1 {
            let pathToDraw = CGMutablePath()
            let line = SKShapeNode()
            pathToDraw.move(to: CGPoint(x: offset, y: offset + CGFloat(n) * rowSize.height))
            pathToDraw.addLine(to: CGPoint(x: offset + board.frame.size.width - 2*line.lineWidth, y: offset + CGFloat(n) * rowSize.height))
            line.path = pathToDraw
            line.strokeColor = SKColor.white
            addChild(line)
            let label = SKLabelNode(text: "\(rounds-n+1)")
            label.position = CGPoint(x: offset*2.5, y: offset + CGFloat(n) * rowSize.height - rowSize.height/2 - label.frame.size.height/2)
            addChild(label)
            
            let playerCircle = SKShapeNode(circleOfRadius: getPlayerCircleRadius(rowSize: rowSize))
            let pinBoardWidth = (rowSize.width - rowSize.height)/CGFloat(pinNumber)/2
            let x = offset + rowSize.height + pinBoardWidth
            let y = offset + CGFloat(n-1) * rowSize.height + rowSize.height/2
            playerCircle.position = CGPoint(x: x, y: y)
//            playerCircle.position = CGPoint(x: offset + rowSize.height + (rowSize.width - rowSize.height)/CFloat(pinNumber)/2, y: offset + CGFloat(n-1) * rowSize.height + rowSize.height/2)
            addChild(playerCircle)
            for i in 1..<pinNumber {
                if let c = playerCircle.copy() as? SKShapeNode{
                    let i1 = 2*i+1
                    let pinBoardWidth = (rowSize.width - rowSize.height)/CGFloat(pinNumber)/2
                    let x = offset + rowSize.height + CGFloat(i1)*pinBoardWidth
                    let y = offset + CGFloat(n-1) * rowSize.height + rowSize.height/2
                    c.position = CGPoint(x: x, y: y)
                    addChild(c)
                }
            }
            
            for k in 1...2 {
                let responseCircle = SKShapeNode(circleOfRadius: (rowSize.width - rowSize.height)/20)
                responseCircle.position = CGPoint(x: 2*offset + CGFloat(k)*rowSize.height/3, y: offset + CGFloat(n-1) * rowSize.height + rowSize.height/4)
                addChild(responseCircle)
            }
            for k in 1...2 {
                let responseCircle = SKShapeNode(circleOfRadius: (rowSize.width - rowSize.height)/20)
                responseCircle.position = CGPoint(x: 2*offset + CGFloat(k)*rowSize.height/3, y: offset + CGFloat(n-1) * rowSize.height + 3*rowSize.height/4)
                addChild(responseCircle)
            }
        }
        let label = SKLabelNode(text: "\(1)")
        label.position = CGPoint(x: offset*2.5, y: offset + board.frame.size.height - rowSize.height/2 - label.frame.size.height/2)
        addChild(label)
        
        let circle = SKShapeNode(circleOfRadius: getPlayerCircleRadius(rowSize: rowSize))
        circle.position = CGPoint(x: offset + rowSize.height + (rowSize.width - rowSize.height)/CGFloat(pinNumber)/2, y: offset + CGFloat(rounds-1) * rowSize.height + rowSize.height/2)
        addChild(circle)
        for i in 1..<pinNumber {
            if let c = circle.copy() as? SKShapeNode{
                let i1 = 2*i+1
                let pinBoardWidth = (rowSize.width - rowSize.height)/CGFloat(pinNumber)/2
                let x = offset + rowSize.height + CGFloat(i1)*pinBoardWidth
                let y = offset + CGFloat(rounds-1) * rowSize.height + rowSize.height/2
                c.position = CGPoint(x: x, y: y)
                addChild(c)
            }
        }
        
        for k in 1...2 {
            let responseCircle = SKShapeNode(circleOfRadius: (rowSize.width - rowSize.height)/20)
            responseCircle.position = CGPoint(x: 2*offset + CGFloat(k)*rowSize.height/3, y: offset + CGFloat(rounds-1) * rowSize.height + rowSize.height/4)
            addChild(responseCircle)
        }
        for k in 1...2 {
            let responseCircle = SKShapeNode(circleOfRadius: (rowSize.width - rowSize.height)/20)
            responseCircle.position = CGPoint(x: 2*offset + CGFloat(k)*rowSize.height/3, y: offset + CGFloat(rounds-1) * rowSize.height + 3*rowSize.height/4)
            addChild(responseCircle)
        }
        let pathToDraw = CGMutablePath()
        let verticalLine = SKShapeNode()
        pathToDraw.move(to: CGPoint(x: offset + rowSize.height, y: offset))
        pathToDraw.addLine(to: CGPoint(x: offset + rowSize.height, y: offset + board.frame.size.height - 2*verticalLine.lineWidth))
        verticalLine.path = pathToDraw
        verticalLine.strokeColor = SKColor.white
        addChild(verticalLine)
        
        
    }
    
    func getPlayerCircleRadius(rowSize: CGSize)->CGFloat{
        return (rowSize.width - rowSize.height)/(CGFloat(pinNumber)*2 + 2)
    }
    
    func getRowSize()->CGSize{
        let boardSize = CGSize(width: frame.size.width - offset*2, height: frame.size.height - offset*2)
        let size = CGSize(width: boardSize.width, height: boardSize.height/CGFloat(rounds))
        return size
    }
    
    func getBoardSize()->CGSize{
        let boardSize = CGSize(width: frame.size.width - offset*2, height: frame.size.height - offset*2)
        return boardSize
    }
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    
//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
}
