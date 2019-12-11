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
    
    // Delegate variable
    weak var delegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerNotification()
    }
}

extension TitleSearchView {
    
    func configure(withTitle title: String, andPlaceholder placeholder: String? = nil, delegate: UITextFieldDelegate? = nil) {
        titleLabel.text = title
        textField.placeholder = placeholder
        self.delegate = delegate
    }
}

extension TitleSearchView {
    
    private func registerNotification() {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newWordFound(notification:)),
                                               name: newAnswerFoundNotification,
                                               object: nil)
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        NotificationCenter.default.post(name: newEntryNotification, object: textField.text)
    }
    
    @objc
    private func newWordFound(notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.textField.text = ""
        }
    }
}
