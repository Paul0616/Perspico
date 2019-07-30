//
//  CheckBoxSprite.swift
//  Perspico
//
//  Created by Paul Oprea on 30/07/2019.
//  Copyright © 2019 Paul Oprea. All rights reserved.
//

import SpriteKit

class CheckBoxSprite: SKSpriteNode {
    
    enum CheckBoxActionType: Int {
        case TouchUpInside = 1,
        TouchDown, TouchUp
    }
    
    var isChecked: Bool = true {
        didSet {
            if checkedTexture != nil {
                texture = isChecked ? checkedTexture : uncheckedTexture
            }
        }
    }
    
    var checkedTexture: SKTexture!
    var uncheckedTexture: SKTexture!
    var label: SKLabelNode
    weak var targetTouchUpInside: AnyObject?
    weak var targetTouchUp: AnyObject?
    weak var targetTouchDown: AnyObject?
//    var actionTouchUpInside: Selector?
//    var actionTouchUp: Selector?
//    var actionTouchDown: Selector?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(checkedTexture: SKTexture!, uncheckedTexture: SKTexture!, text: String!){
        self.checkedTexture = checkedTexture
        self.uncheckedTexture = uncheckedTexture
        self.label = SKLabelNode(fontNamed: "Rockwell")
        self.label.text = text
        self.label.fontSize = 30.0
        self.label.fontColor = UIColor.white
        
        let texture = isChecked ? checkedTexture : uncheckedTexture
        super.init(texture: texture, color: UIColor.white, size: texture!.size())
        isUserInteractionEnabled = true
        
        self.label.verticalAlignmentMode = .center
        self.label.horizontalAlignmentMode = .center
        self.label.position = CGPoint(x: self.position.x - self.label.frame.size.width - frame.size.width, y: self.position.y)
        let size = CGSize(width: self.label.frame.size.width + 10 + self.size.width, height: CGFloat.maximum(self.label.frame.size.height, self.frame.size.height))
        self.size = size
        addChild(self.label)
        
//        let bugFixLayerNode = SKSpriteNode(texture: nil, color: UIColor.clear, size: frame.size)
//        bugFixLayerNode.position = self.position
//        addChild(bugFixLayerNode)
    }
    
    func setCkeckedAction(target: AnyObject, triggerEvent event: CheckBoxActionType){
        switch (event) {
        case .TouchUpInside:
            targetTouchUpInside = target
//            actionTouchUpInside = action
        case .TouchDown:
            targetTouchDown = target
//            actionTouchDown = action
        case .TouchUp:
            targetTouchUp = target
//            actionTouchUp = action
        }
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if (targetTouchDown != nil ){ //&& targetTouchDown!.responds(to: actionTouchDown!)
//            UIApplication.shared.sendAction(nil, to: targetTouchDown, from: self, for: nil)
//        }
//    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch: AnyObject! = touches.first
//        let touchLocation = touch.location(in: parent!)
//
////        if (frame.contains(touchLocation)) {
////            isSelected = true
////        } else {
////            isSelected = false
////        }
//    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (targetTouchUpInside != nil ) { //&& targetTouchUpInside!.responds(to: actionTouchUpInside!)
            let touch: AnyObject! = touches.first
            let touchLocation = touch.location(in: parent!)
            
            if (frame.contains(touchLocation) ) {
               // UIApplication.shared.sendAction(actionTouchUpInside!, to: targetTouchUpInside, from: self, for: nil)
                isChecked = !isChecked
            }
            
        }
        
//        if (targetTouchUp != nil && targetTouchUp!.responds(to: actionTouchUp!)) {
//            UIApplication.shared.sendAction(actionTouchUp!, to: targetTouchUp, from: self, for: nil)
//        }
        
    }
    
}
