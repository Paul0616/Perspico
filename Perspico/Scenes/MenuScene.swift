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
//        let uncheckedTexture = SKTexture(imageNamed: "unchecked")
//        let checkMedium = CheckBoxSprite(checkedTexture: checkedTexture, uncheckedTexture: uncheckedTexture, text: "Medium")
//        checkMedium.setCkeckedAction(target: self, triggerEvent: .TouchUpInside)
//        checkMedium.position = CGPoint(x: frame.midX, y: score.frame.minY - checkMedium.frame.size.height)
//        checkMedium.size = CGSize(width: frame.size.width/8, height: frame.size.width / 8)
//        addChild(checkMedium)
        let medium = CheckSprite(checkedTexture: checkedTexture, uncheckedTexture: uncheckedTexture)//SKSpriteNode(texture: checkedTexture)
        medium.size = CGSize(width: frame.size.width / 8, height: frame.size.width / 8)
        medium.position = CGPoint(x: frame.midX, y: score.frame.minY - medium.frame.size.height)
        medium.name = "medium"
//        medium.color = .white
//        medium.colorBlendFactor = 1.0
        //medium.setChecked(isChecked: false)
        //medium.isChecked = false
        
        addChild(medium)
        let label = SKLabelNode(fontNamed: "Rockwell")
        label.text = "Medium"
        label.fontSize = 30.0
        label.fontColor = UIColor.white
        label.position = CGPoint(x: medium.frame.minX - 10 - label.frame.width/2, y: medium.frame.midY - label.frame.height/2)
        addChild(label)
        
       
        //medium.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 1))
        //medium
    }
    
//    @objc func checkTapped(){
//        
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let node: SKNode = self.atPoint(location)
            if node.name == "medium", let n = node as? CheckSprite {
                print("medium")
                
                n.setChecked(isChecked: !n.isChecked)
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
