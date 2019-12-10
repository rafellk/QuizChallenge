//
//  CurvedButton.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/9/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

class CurvedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyle()
    }
    
    private func configureStyle() {
        layer.cornerRadius = 8
    }
}
