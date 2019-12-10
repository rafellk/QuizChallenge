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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        // todo: localize this and get this from the view model instead
        titleView.configure(withTitle: "What are all Java keywords",
                            andPlaceholder: "Insert word")
    }
}
