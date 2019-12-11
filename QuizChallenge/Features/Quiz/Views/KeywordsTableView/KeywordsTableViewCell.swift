//
//  KeywordsTableViewCell.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/10/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

class KeywordsTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyle()
    }
    
    private func configureStyle() {
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        selectionStyle = .none
    }
}
