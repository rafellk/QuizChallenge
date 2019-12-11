//
//  KeywordsTableView.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/9/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

class KeywordsTableView: UITableView {
    
    private var foundWords = [String]() {
        didSet {
            if foundWords.count > 0 {
                DispatchQueue.main.async { [weak self] in
                    self?.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureDelegates()
        configureTableViewCell()
        
        registerNotifications()
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
        return foundWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: "keywordsTableViewCellID") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = foundWords[indexPath.row]
        
        return cell
    }
}

extension KeywordsTableView {
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newWordFound(notification:)),
                                               name: newAnswerFoundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resetGame),
                                               name: resetGameNotification,
                                               object: nil)
    }
    
    @objc
    private func newWordFound(notification: Notification) {
        if let tuple = notification.object as? (String, [String]) {
            foundWords = tuple.1
        }
    }

    @objc
    private func resetGame() {
        foundWords.removeAll()
        reloadData()
    }
}
