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
    @IBOutlet weak var statusViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: KeywordsTableView!
    
    // Keyboard animation variables
    private var initialStatusViewY: CGFloat?
    private var initialStatusViewBackgroundY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configure()
        registerNotifications()
        
        initialStatusViewY = statusViewBottomConstraint.constant
        initialStatusViewBackgroundY = backgroundBottomConstraint.constant
    }
    
    private func configure() {
        // todo: localize this and get this from the view model instead
        titleView.configure(withTitle: "What are all Java keywords?",
                            andPlaceholder: "Insert Word")
        hideKeyboardWhenTappedAround()
    }
}

// Notifications extension
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

            if statusViewBottomConstraint.constant == initialStatusViewY {
                view.layoutIfNeeded()

                statusViewBottomConstraint.constant += keyboardSize.height
                backgroundBottomConstraint.constant += keyboardSize.height

                view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        if let initialStatusViewY = initialStatusViewY,
            let initialStatusViewBackgroundY = initialStatusViewBackgroundY,
            statusViewBottomConstraint.constant != initialStatusViewY {
            view.layoutIfNeeded()
            
            statusViewBottomConstraint.constant = initialStatusViewY
            backgroundBottomConstraint.constant = initialStatusViewBackgroundY
            
            view.layoutIfNeeded()
        }
    }
}

extension MainViewController {
    
    private func hideKeyboardWhenTappedAround() {
        registerDismissKeyboardGesture(forView: titleView)
        registerDismissKeyboardGesture(forView: tableView)
    }
    
    private func registerDismissKeyboardGesture(forView theView: UIView) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        theView.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
