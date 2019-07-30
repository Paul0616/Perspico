//
//  CheckSprite.swift
//  Perspico
//
//  Created by Paul Oprea on 30/07/2019.
//  Copyright © 2019 Paul Oprea. All rights reserved.
//

import SpriteKit

class CheckSprite: SKSpriteNode {
    
    var checkedTexture: SKTexture!
    var uncheckedTexture: SKTexture!
    
    var isChecked: Bool = true {
        didSet {
            //if checkedTexture != nil {
                texture = isChecked ? checkedTexture : uncheckedTexture
            color = .white
            colorBlendFactor = 1.0
         //   }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("NSCoding not supported")
    }
    
    
    
   init(checkedTexture: SKTexture!, uncheckedTexture: SKTexture!){
        let texture = self.isChecked ? checkedTexture : uncheckedTexture
        super.init(texture: texture, color: UIColor.white, size: texture!.size())
        //color = UIColor.white
        //colorBlendFactor = 1.0
        
        
    }
    func setChecked(isChecked: Bool){
        self.isChecked = isChecked
        //texture = isChecked ? checkedTexture : uncheckedTexture
    }
}
