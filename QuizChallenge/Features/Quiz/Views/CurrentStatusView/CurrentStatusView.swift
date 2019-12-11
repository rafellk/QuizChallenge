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
    @IBOutlet private weak var resetButton: CurvedButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        if let newView = Bundle.main.loadNibNamed("CurrentStatusView", owner: self, options: nil)?.first as? UIView {
            addSubview(newView)
            newView.frame = bounds
            newView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyle()
        registerNotifications()
    }
    
    private func configureStyle() {
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        clear()
    }
    
    private func clear() {
        scoreLabel.text = "00/00"
        timeLabel.text = "00:00"
    }
}

extension CurrentStatusView {
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(elapsedTimeChanged(notification:)),
                                               name: elapsedTimeNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newWordFound(notification:)),
                                               name: newAnswerFoundNotification,
                                               object: nil)
    }
    
    @objc
    private func elapsedTimeChanged(notification: Notification) {
        if let time = notification.object as? String {
            DispatchQueue.main.async { [weak self] in
                self?.timeLabel.text = time
            }
        }
    }
    
    @objc
    private func newWordFound(notification: Notification) {
        if let score = notification.object as? (String, [String]) {
            DispatchQueue.main.async { [weak self] in
                self?.scoreLabel.text = score.0
            }
        }
    }
}

extension CurrentStatusView {
    
    @objc
    private func resetButtonPressed() {
        NotificationCenter.default.post(name: resetGameNotification, object: nil)
    }
}
