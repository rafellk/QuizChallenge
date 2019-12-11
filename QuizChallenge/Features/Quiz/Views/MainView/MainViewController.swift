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
    @IBOutlet weak var tableView: KeywordsTableView!
    
    private var progressView: UIView?
    
    // Keyboard animation variables
    private var initialStatusViewY: CGFloat?
    private var initialStatusViewBackgroundY: CGFloat?
    
    @IBOutlet weak var statusViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundBottomConstraint: NSLayoutConstraint!
    
    // View Model
    private var viewModel: QuizViewModel?
    
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
                            andPlaceholder: "Insert Word",
                            delegate: self)
        hideKeyboardWhenTappedAround()
        configureViewModel()
    }
    
    private func configureViewModel() {
        viewModel = QuizViewModel(withPresenter: self)
        
        viewModel?.onIsProcessing = { [weak self] isProcessing in
            if isProcessing {
                if let safeSelf = self {
                    safeSelf.progressView = safeSelf.progressView ??
                        ProgressView.instance(inRect: safeSelf.view.frame)
                    UIView.animate(withDuration: 1) {
                        DispatchQueue.main.async {
                            safeSelf.view.addSubview(safeSelf.progressView!)
                        }
                    }
                }
            } else {
                UIView.animate(withDuration: 1) {
                    DispatchQueue.main.async {
                        self?.progressView?.removeFromSuperview()
                    }
                }
            }
        }
        
        viewModel?.start()
    }
}

// Notifications extension
extension MainViewController {
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.layoutIfNeeded()

            statusViewBottomConstraint.constant += keyboardSize.height
            backgroundBottomConstraint.constant += keyboardSize.height

            view.layoutIfNeeded()
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

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        view.endEditing(true)
        return false
    }
}
