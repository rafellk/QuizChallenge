//
//  CurrentStatusView.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/9/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

class CurrentStatusView: UIView {
    
    // IBOutlet variables
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet weak var resetButton: CurvedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyle()
    }
    
    private func configureStyle() {
        // todo: localize this string
        resetButton.setTitle("Reset", for: .normal)
    }
}

extension CurrentStatusView {
    
    func configure() {
        // todo: register time notifications here
    }
}
