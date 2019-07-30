//
//  MenuScene.swift
//  Perspico
//
//  Created by Paul Oprea on 29/07/2019.
//  Copyright © 2019 Paul Oprea. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 40/255, green: 60/255, blue: 80/255, alpha: 1.0)
        createLabels()
    }
    
    func createLabels(){
        let gameOver = SKLabelNode(text: UserDefaults.standard.string(forKey: "MessageGameOver"))
        gameOver.fontName = "Rockwell"
        gameOver.fontSize = 50.0
        gameOver.fontColor = UIColor.white
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.numberOfLines = 0
        gameOver.preferredMaxLayoutWidth = frame.size.width*0.8
        gameOver.horizontalAlignmentMode = .center
        addChild(gameOver)
        animate(label: gameOver)
        
        
        let highScore = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "Highscore"))")
        highScore.fontName = "Rockwell"
        highScore.fontSize = 40.0
        highScore.fontColor = UIColor.white
        highScore.position = CGPoint(x: frame.midX, y: frame.midY - highScore.frame.size.height*4)
        
        addChild(highScore)
        
        let score = SKLabelNode(text: "Score: \(UserDefaults.standard.integer(forKey: "Score"))")
        score.fontName = "Rockwell"
        score.fontSize = 40.0
        score.fontColor = UIColor.white
        score.position = CGPoint(x: frame.midX, y: frame.midY - highScore.frame.size.height*4 - score.frame.size.height*2)
        
        addChild(score)
        
        let medium = SKNode()
        //medium
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
    
    func animate(label: SKLabelNode){
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        label.run(SKAction.repeatForever(sequence))
    }
}
