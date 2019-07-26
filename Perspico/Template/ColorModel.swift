//
//  ColorModel.swift
//  Perspico
//
//  Created by Paul Oprea on 26/07/2019.
//  Copyright © 2019 Paul Oprea. All rights reserved.
//

import UIKit

class ColorModel: NSObject {
    var colorName: String
    var color: UIColor
    
    //MARK: - Initializare
    init(colorName: String, color: UIColor) {
        //Initializeaza proprietatile
        self.colorName = colorName
        self.color = color
    }
    
    
}
