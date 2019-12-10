//
//  KeywordsTableView.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/9/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

class KeywordsTableView: UITableView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureDelegates()
        configureTableViewCell()
    }
    
    private func configureTableViewCell() {
        register(KeywordsTableViewCell.self, forCellReuseIdentifier: "keywordsTableViewCellID")
    }
    
    private func configureDelegates() {
        dataSource = self
    }
}

extension KeywordsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: "keywordsTableViewCellID") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = "java"
        
        return cell
    }
}
