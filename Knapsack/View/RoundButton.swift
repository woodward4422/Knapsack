//
//  RoundButton.swift
//  Knapsack
//
//  Created by Noah Woodward on 8/8/18.
//  Copyright © 2018 Noah Woodward. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
