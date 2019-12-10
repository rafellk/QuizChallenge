//
//  ViewController.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/9/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // IBOutlet variables
    @IBOutlet weak var titleView: TitleSearchView!
    @IBOutlet weak var currentStatusBackgroundView: UIView!
    @IBOutlet weak var statusView: CurrentStatusView!
    
    // Keyboard animation variables
    private var initialStatusViewY: CGFloat?
    private var initialStatusViewBackgroundY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        registerNotifications()
        initialStatusViewY = statusView.frame.origin.y
        initialStatusViewBackgroundY = currentStatusBackgroundView.frame.origin.y
    }
    
    private func configure() {
        // todo: localize this and get this from the view model instead
        titleView.configure(withTitle: "What are all Java keywords?",
                            andPlaceholder: "Insert Word")
    }
}

extension MainViewController {
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MainViewController.keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MainViewController.keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    

    @objc
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let initialStatusViewY = initialStatusViewY {
            if statusView.frame.origin.y == initialStatusViewY {
                statusView.frame.origin.y -= keyboardSize.height
                currentStatusBackgroundView.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        if statusView.frame.origin.y != 0 &&
           currentStatusBackgroundView.frame.origin.y != 0 {
            statusView.frame.origin.y = initialStatusViewY ?? 0
            currentStatusBackgroundView.frame.origin.y = initialStatusViewBackgroundY ?? 0
        }
    }
}
