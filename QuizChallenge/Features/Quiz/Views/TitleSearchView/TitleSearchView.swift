//
//  TitleSearchView.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/9/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

class TitleSearchView: UIView {
    
    // IBOutlet variables
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: QuizTextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        if let newView = Bundle.main.loadNibNamed("TitleSearchView", owner: self, options: nil)?.first as? UIView {
            addSubview(newView)
            newView.frame = bounds
            newView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
    // IBOutlet variables
    weak var delegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
}

extension TitleSearchView {
    
    private func configure(withTitle title: String,
                           andDelegate delegate: UITextFieldDelegate) {
        titleLabel.text = title
        self.delegate = delegate
    }
}
