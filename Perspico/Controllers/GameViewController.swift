//
//  GameViewController.swift
//  Perspico
//
//  Created by Paul Oprea on 24/07/2019.
//  Copyright © 2019 Paul Oprea. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
           
           let scene = GameScene(size: view.bounds.size)//SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
