//
//  BaseViewModel.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/10/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

class BaseViewModel {
    
    weak var presenter: UIViewController?
    
    init(withPresenter presenter: UIViewController) {
        self.presenter = presenter
    }
}

extension BaseViewModel {
    
    func shouldHandleError(withError error: Error?) -> Bool {
        // todo: handle errors here
        return false
    }
}
