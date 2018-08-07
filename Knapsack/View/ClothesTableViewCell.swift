//
//  ClothesTableViewCell.swift
//  Knapsack
//
//  Created by Noah Woodward on 8/1/18.
//  Copyright © 2018 Noah Woodward. All rights reserved.
//

import UIKit

protocol ClothingTableViewCellDelegate: class {
    func clothing(_ cell: ClothesTableViewCell, didTapOn checkButton: UIButton)
}

class ClothesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clothesLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    weak var delegate: ClothingTableViewCellDelegate?
    
    @IBAction func pressCheckbox(_ button: UIButton) {
        
        //toggling the checkbox button here
        button.isSelected = !button.isSelected
        
        //then notify the delegate
        delegate?.clothing(self, didTapOn: button)
    }
    
    func configure(clothing: Clothing) {
        self.clothesLabel.text = clothing.title
        self.checkButton.isSelected = clothing.isChecked
    }
    
}
