//
//  NotificationsHelper.swift
//  QuizChallengeTests
//
//  Created by Rafael Lucena on 12/11/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import Foundation
@testable import QuizChallenge

typealias NewWordFoundCallback = ((String, [String])) -> Void
typealias ElapsedTimeCallback = (String) -> Void

class NotificationsHelper {
    
    var newWordFoundCallback: NewWordFoundCallback?
    var elapsedTimeCallback: ElapsedTimeCallback?
    
    init() {
        registerNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newWordFound(notification:)),
                                               name: newAnswerFoundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(elapsedTime(notification:)),
                                               name: elapsedTimeNotification,
                                               object: nil)
    }
    
    @objc
    private func newWordFound(notification: Notification) {
        if let tuple = notification.object as? (String, [String]) {
            newWordFoundCallback?(tuple)
        }
    }

    @objc
    private func elapsedTime(notification: Notification) {
        if let time = notification.object as? String {
            elapsedTimeCallback?(time)
        }
    }
}
