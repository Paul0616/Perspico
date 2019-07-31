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
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY+frame.size.height/4)
        gameOver.numberOfLines = 0
        gameOver.preferredMaxLayoutWidth = frame.size.width*0.8
        gameOver.horizontalAlignmentMode = .center
        gameOver.name = "play"
        addChild(gameOver)
        animate(label: gameOver)
        
        
        let highScore = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "Highscore"))")
        highScore.fontName = "Rockwell"
        highScore.fontSize = 40.0
        highScore.fontColor = UIColor.white
        highScore.position = CGPoint(x: frame.midX, y: gameOver.frame.minY - highScore.frame.size.height*4)
        
        addChild(highScore)
        
        let score = SKLabelNode(text: "Score: \(UserDefaults.standard.integer(forKey: "Score"))")
        score.fontName = "Rockwell"
        score.fontSize = 40.0
        score.fontColor = UIColor.white
        score.position = CGPoint(x: frame.midX, y: gameOver.frame.minY - highScore.frame.size.height*4 - score.frame.size.height*2)
        
        addChild(score)
        let checkedTexture = SKTexture(imageNamed: "checked")
        let uncheckedTexture = SKTexture(imageNamed: "unchecked")

        let medium = CheckSprite(checkedTexture: checkedTexture, uncheckedTexture: uncheckedTexture)//SKSpriteNode(texture: checkedTexture)
        medium.size = CGSize(width: frame.size.width / 8, height: frame.size.width / 8)
        medium.position = CGPoint(x: frame.midX+frame.size.width/4, y: score.frame.minY - 3*medium.frame.size.height)
        medium.name = "medium"
        if let difficulty = UserDefaults.standard.string(forKey: "Difficulty") {
            medium.isChecked = difficulty == "medium" ? true : false
        } else {
            medium.isChecked = true
        }
        addChild(medium)
    
        let labelMedium = SKLabelNode(fontNamed: "Rockwell")
        labelMedium.text = "Medium"
        labelMedium.fontSize = 30.0
        labelMedium.fontColor = UIColor.white
        labelMedium.position = CGPoint(x: medium.frame.minX - 10 - labelMedium.frame.width/2, y: medium.frame.midY - labelMedium.frame.height/2)
        addChild(labelMedium)
        
        let hard = CheckSprite(checkedTexture: checkedTexture, uncheckedTexture: uncheckedTexture)//SKSpriteNode(texture: checkedTexture)
        hard.size = CGSize(width: frame.size.width / 8, height: frame.size.width / 8)
        hard.position = CGPoint(x: frame.midX+frame.size.width/4, y: medium.frame.minY - hard.frame.size.height)
        hard.name = "hard"
        if let difficulty = UserDefaults.standard.string(forKey: "Difficulty") {
            hard.isChecked = difficulty == "hard" ? true : false
        } else {
            hard.isChecked = false
        }
        addChild(hard)
        
        let labelHard = SKLabelNode(fontNamed: "Rockwell")
        labelHard.text = "Hard"
        labelHard.fontSize = 30.0
        labelHard.fontColor = UIColor.white
        labelHard.position = CGPoint(x: hard.frame.minX - 10 - labelHard.frame.width/2, y: hard.frame.midY - labelHard.frame.height/2)
        addChild(labelHard)
       
        //medium.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 1))
        
    }
    
//    @objc func checkTapped(){
//        
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let node: SKNode = self.atPoint(location)
            if node == childNode(withName: "medium"), let n = node as? CheckSprite {
                print("medium")
                n.isChecked = !n.isChecked
                let hard = childNode(withName: "hard") as? CheckSprite
                hard?.isChecked = !hard!.isChecked
                UserDefaults.standard.set("medium", forKey: "Difficulty")
                pinNumber = 4
                rounds = 6
            }
            if node == childNode(withName: "hard"), let n = node as? CheckSprite {
                print("hard")
                n.isChecked = !n.isChecked
                childNode(withName: "hard")
                let medium = childNode(withName: "medium") as? CheckSprite
                medium?.isChecked = !medium!.isChecked
                UserDefaults.standard.set("hard", forKey: "Difficulty")
                pinNumber = 5
                rounds = 9
            }
            if node.name == "play" {
                let gameScene = GameScene(size: view!.bounds.size)
                view!.presentScene(gameScene)
            }
           
        }
    
    }
    
    func animate(label: SKLabelNode){
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        label.run(SKAction.repeatForever(sequence))
    }
    
    
}
