//
//  ProgressView.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/10/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainer()
    }
    
    private func configureContainer() {
        containerView.layer.cornerRadius = 16
    }
    
    static func instance(inRect rect: CGRect) -> UIView? {
        if let newView = Bundle.main.loadNibNamed("ProgressView",
                                                  owner: self,
                                                  options: nil)?.first as? UIView {
            newView.frame = rect
            newView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            return newView
        }
        
        return nil
    }
}
