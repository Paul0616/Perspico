//
//  GameScene.swift
//  Perspico
//
//  Created by Paul Oprea on 24/07/2019.
//  Copyright © 2019 Paul Oprea. All rights reserved.
//

import SpriteKit


class GameScene: SKScene {
    
    let colors6: [ColorModel] = [
        ColorModel(colorName: "yellow", color: UIColor.yellow ),
        ColorModel(colorName: "red", color: UIColor.red ),
        ColorModel(colorName: "purple", color: UIColor.purple ),
        ColorModel(colorName: "green", color: UIColor.green),
        ColorModel(colorName: "brown", color: UIColor.brown ),
        ColorModel(colorName: "orange", color: UIColor.orange )
    ]
    let colors7: [ColorModel] = [
        ColorModel(colorName: "yellow", color: UIColor.yellow ),
        ColorModel(colorName: "red", color: UIColor.red ),
        ColorModel(colorName: "purple", color: UIColor.purple ),
        ColorModel(colorName: "green", color: UIColor.green),
        ColorModel(colorName: "brown", color: UIColor.brown ),
        ColorModel(colorName: "orange", color: UIColor.orange ),
        ColorModel(colorName: "blue", color: UIColor.blue )
    ]
    var colorPickNodes: [SKShapeNode] = []
    var currentPlayerNodes: [SKShapeNode] = []
    var movableColor: SKShapeNode!
    var currentRow: Int = 0
    var currentRandomColors: [ColorModel] = []
    var roundTimeStart: CFloat = 0.0
    var roundTimeStop: CFloat = 0.0
    var score: Int = 0
    var scoreLabel: SKLabelNode!
  
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        if pinNumber == 4 {
            currentRandomColors = randomColors(number: pinNumber, colors: colors6)
        }
        if pinNumber == 5 {
            currentRandomColors = randomColors(number: pinNumber, colors: colors7)
        }
       layoutScene()
        roundTimeStart = getTime()

    }
    
    
    func layoutScene(){
        createGameBoard()
        createPickColorsSection()
        createScore()
//        for position in 0..<pinNumber{
//            createPlayerPins(row: 5, position: position, color: currentRandomColors[position].color)
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
        var colors_used: [ColorModel]!
        if pinNumber == 4{
            colors_used = self.colors6
        }
        if pinNumber == 5{
            colors_used = self.colors7
        }
        for color in colors_used {
            let pickCircle = SKShapeNode(circleOfRadius: getPlayerCircleRadius(rowSize: rowSize))
            pickCircle.strokeColor = UIColor.clear
            pickCircle.fillColor = color.color
            let i = 2*index + 1
            let x = offset + CGFloat(i)*(rowSize.width/CGFloat(colors_used.count)/2)
            let y = offset + CGFloat(rounds) * rowSize.height + rowSize.height/2
            pickCircle.position = CGPoint(x: x, y: y)
            pickCircle.name = color.colorName
            
            
            UIGraphicsBeginImageContextWithOptions(rowSize, true, 1.0)
            let context = UIGraphicsGetCurrentContext()!// UIGraphicsGetCurrentContext()
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0,y: 0,width: rowSize.width,height: rowSize.height)
            gradient.colors = [SKColor.white.cgColor,SKColor.black.cgColor]
            gradient.type = .radial
            gradient.startPoint = CGPoint(x: 0.7, y: 0.2)
            gradient.endPoint = CGPoint(x: 1 , y: 1)
            gradient.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let texture = SKTexture(cgImage: (image?.cgImage)!)
            pickCircle.fillTexture = texture
            colorPickNodes.append(pickCircle)
            addChild(pickCircle)
            index += 1
        }
    }
    func createScore(){
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 18
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.minX + scoreLabel.frame.size.width/2 + offset, y: frame.maxY - scoreLabel.frame.size.height-offset)
        
        addChild(scoreLabel)
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
       
            let rowSize = getRowSize()
            let responseCircle = SKShapeNode(circleOfRadius: getPlayerCircleRadius(rowSize: rowSize)/3)
            if(position<4){
                let k = position/2*2 + 1
                responseCircle.position = CGPoint(x: 2*offset + CGFloat(position%2+1)*rowSize.height/3, y: offset + CGFloat(rounds-row-1) * rowSize.height + CGFloat(k)*rowSize.height/4)
            }
            if position==4{
                responseCircle.position = CGPoint(x: 2*offset + rowSize.height/2, y: offset + CGFloat(rounds-row-1) * rowSize.height + rowSize.height/2)
            }
            responseCircle.strokeColor = UIColor.clear
            if correctPosition {
                responseCircle.fillColor = UIColor.black
            } else {
                responseCircle.fillColor = UIColor.white
            }
            responseCircle.alpha = 0
            
            addChild(responseCircle)
            animate1(node: responseCircle, position: position)
       
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
    
    func randomColors(number: Int, colors: [ColorModel]) -> [ColorModel] {
        var rand = [ColorModel]()
        guard number > 0 else { return rand }
        var remaining = colors
        //var names = colorNames
        for _ in 0 ..< number {
            guard !remaining.isEmpty else { break }
            let randomIndex = Int(arc4random_uniform(UInt32(remaining.count)))
            rand.append(remaining[randomIndex])
            //names.remove(at: randomIndex)
            remaining.remove(at: randomIndex)
        }
        return rand
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
    func getTime()->CFloat{
        let hh2 = (Calendar.current.component(.hour, from: Date()))
        let mm2 = (Calendar.current.component(.minute, from: Date()))
        let ss2 = (Calendar.current.component(.second, from: Date()))
        return CFloat(hh2)*3600.0 + CFloat(mm2)*60.0 + CFloat(ss2)
   
    }
    
    func addScoreLabel(score: Int, isBonus: Bool){
        let prefix = isBonus ? "Bonus:+" : "+"
        
        let addScore = SKLabelNode(text: "\(prefix)\(score)")
       
        addScore.fontName = "Rockwell-Bold"
        addScore.fontSize = 60.0
        addScore.fontColor = UIColor.white
        addScore.position = CGPoint(x: frame.midX, y: frame.midY)

        addChild(addScore)
    
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let fadeout = SKAction.fadeOut(withDuration: 0.5)
        let sequence = SKAction.sequence([scaleDown, fadeout])
        addScore.run(SKAction.repeat(sequence, count: 1), completion: {() -> Void in
            addScore.removeFromParent()
        })
    }
    
    func getResponse(){
        roundTimeStop = getTime()
        let t = roundTimeStop - roundTimeStart
        
        score += Int(1/t*100)
        roundTimeStart = getTime()
//        if let sc = scoreLabel {
//            sc.text = "Score \(score)"
//        }
        var whites = 0
        var blacks = 0
        var i = 0
        var j = 0
        for nodePlayer in currentPlayerNodes {
            //print(nodePlayer.name!)
            for nodeRandom in currentRandomColors {
                let nameColorRandom = nodeRandom.colorName
                let nameColorPlayer = nodePlayer.name!
                if nameColorPlayer == nameColorRandom {//nodePlayer.fillColor == nodeRandom.color {
                    print("\(String(describing: nodePlayer.name)) == \(nodeRandom.colorName)")
                    if i == j {
                        print("\(i) - \(nodeRandom.colorName)")
                       blacks += 1
                    } else {
                        print("\(nodeRandom.colorName)")
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
        
        for position in whites..<(blacks+whites){
            createResponse(row: currentRow, position: position, correctPosition: true)
        }
        
        print("\(whites) - \(blacks)")
        if blacks == pinNumber {
            let f = CFloat(1/CFloat(self.currentRow+1))
            print(Int(f*CFloat(pinNumber%3*200)))
            self.score += Int(f*CFloat(pinNumber%3*200))
            addScoreLabel(score: Int(f*CFloat(pinNumber%3*200)), isBonus: true)
            self.currentRow = 0
            run(SKAction.playSoundFileNamed("ta-da.mp3", waitForCompletion: true)) {
                UserDefaults.standard.set("You won!\nTap to play again.", forKey: "MessageGameOver")
                UserDefaults.standard.set(self.score, forKey: "Score")
                if self.score > UserDefaults.standard.integer(forKey: "Highscore"){
                    UserDefaults.standard.set(self.score, forKey: "Highscore")
                }
                let menuScene = MenuScene(size: self.view!.bounds.size)
                self.view!.presentScene(menuScene)
            }
            
        } else {
            if currentRow == rounds-1 {
                run(SKAction.playSoundFileNamed("game_over", waitForCompletion: true)) {
                    self.currentRow = 0
                    UserDefaults.standard.set("You lost!\nTap to play again.", forKey: "MessageGameOver")
                    UserDefaults.standard.set(self.score, forKey: "Score")
                    if self.score > UserDefaults.standard.integer(forKey: "Highscore"){
                        UserDefaults.standard.set(self.score, forKey: "Highscore")
                    }
                    let menuScene = MenuScene(size: self.view!.bounds.size)
                    self.view!.presentScene(menuScene)
                }
            } else {
                addScoreLabel(score:Int(1/t*100), isBonus: false)
            }
        }
        if let sc = scoreLabel {
            sc.text = "Score \(score)"
        }
    }

    
    func animate1(node: SKNode, position: Int){
        let sound = SKAction.playSoundFileNamed("pop1.wav", waitForCompletion: false)
        let delayAction = SKAction.wait(forDuration: TimeInterval(position)*0.2)
        let scaleUp = SKAction.scale(to: 1.3, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        let fadein = SKAction.fadeIn(withDuration: 0.2)
        let sequence = SKAction.sequence([delayAction, sound, fadein, scaleUp, scaleDown ])
        node.run(SKAction.repeat(sequence, count: 1))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if(touch.tapCount == 1){
                for node in colorPickNodes{
                    if node.contains(location), movableColor == nil {
                        if let n = node.copy() as? SKShapeNode{
                            print(touch.tapCount)
                            print("START drag")
                            movableColor = n
                            movableColor!.position = location
                            addChild(movableColor)
                        }
                    }
                }
            }
            if(touch.tapCount == 2){
                print("DOUBLE")
                var selectedNode: SKShapeNode!
                for node in colorPickNodes{
                    if node.contains(location){
                        selectedNode = node
                        break
                    }
                }
                for node in currentPlayerNodes {
                    if node.strokeColor == UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), selectedNode != nil {
                        node.strokeColor = UIColor.clear
                        node.fillColor = selectedNode.fillColor
                        node.name = selectedNode.name
                        break
                    }
                }
                if checkCurrentNodesIsFilled() {
                    getResponse()
                    if currentRow < rounds-1 {
                        nextRound()
                    }
                }
            }
        }
    }
        
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            if movableColor != nil{
                movableColor.removeFromParent()
            }
            movableColor = nil
            print("STOP - cancel drag")
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
                    node.name = movableColor.name
                } else {
                    if node.name == movableColor.name {
                        node.strokeColor = UIColor.white
                        node.fillColor = UIColor.clear
                    }
                }
            }
            movableColor!.position = touch.location(in: self)
            movableColor.removeFromParent()
            movableColor = nil
            print("STOP - end drag")
            if checkCurrentNodesIsFilled() {
                getResponse()
                if currentRow < rounds-1 {
                    nextRound()
                }
            }
        }
    }

//    override func update(_ currentTime: TimeInterval) {
//        // Called before each frame is rendered
//    }
}
