//
//  BaseViewModel.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/10/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

enum QuizError: Error {
    case timeout
    
    var localizedDescription: String {
        switch self {
        case .timeout:
            return "The request timed out. Try again."
        }
    }
}

class BaseViewModel {
    
    weak var presenter: UIViewController?
    
    init(withPresenter presenter: UIViewController) {
        self.presenter = presenter
    }
}

extension BaseViewModel {
    
    func shouldHandleError(withError error: Error?,
                           retryOperation operation: (() -> Void)? = nil) -> Bool {
        if error == nil {
            return false
        }
        
        presentErrorDialog(forError: error, retryOperation: operation)
        return true
    }
}

extension BaseViewModel {
    
    private func presentErrorDialog(forError error: Error?,
                                    retryOperation operation: (() -> Void)? = nil) {
        var message = error?.localizedDescription
        
        if let quizError = error as? QuizError {
            message = quizError.localizedDescription
        }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) { (_) in
            operation?()
        }
        
        alertController.addAction(action)
        DispatchQueue.main.async { [weak self] in
            self?.presenter?.present(alertController, animated: true, completion: nil)
        }
    }
}
