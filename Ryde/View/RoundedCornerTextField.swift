//
//  RoundedCornerTextField.swift
//  Ryde
//
//  Created by Sean Sutton on 1/22/18.
//  Copyright © 2018 Au Development. All rights reserved.
//

import UIKit

class RoundedCornerTextField: UITextField {

    override func awakeFromNib() {
        setupView()
        
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.height / 2
        
    }
    
}
