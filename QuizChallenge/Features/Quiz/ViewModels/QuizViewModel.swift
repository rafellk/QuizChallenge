//
//  QuizViewModel.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/10/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

struct QuizModel {
    var seconds: Int
    var numberOfWords: Int
    var foundWords: Int

    // todo: format the correct way
    func formattedSeconds() -> String {
        return "\(seconds / 60):\(seconds % 60)"
    }
}

class QuizViewModel {
    
    private var timer: Timer?
    private var model: QuizModel?
    
    init() {
        resetTimer()
    }
}

extension QuizViewModel {
    
    private func resetTimer() {
        model = QuizModel(seconds: 300, numberOfWords: 50, foundWords: 7)
        NotificationCenter.default.post(name: elapsedTimeNotification, object: model!.formattedSeconds())
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.model?.seconds -= 1
            
            if let seconds = self?.model?.seconds,
               let formattedSeconds = self?.model?.formattedSeconds() {
                NotificationCenter.default.post(name: elapsedTimeNotification, object: formattedSeconds)
                
                if seconds == 0 {
                    // todo: handle the game over here.
                    self?.timer?.invalidate()
                }
            }
        })
    }
}
