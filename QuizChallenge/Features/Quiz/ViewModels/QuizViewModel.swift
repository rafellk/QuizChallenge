//
//  QuizViewModel.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/10/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

struct QuizViewModelSource {
    var seconds: Int = 300
    var foundWords: [String]
    var answers: [String]

    private func formatted(value: Int, numberOfNumbers: Int) -> String {
        var string = "\(value)"
        let remainingZeros = (numberOfNumbers) - string.count
        
        for _ in 0..<remainingZeros {
            string = "0\(string)"
        }
        
        return string
    }
    
    // todo: format the correct way
    func formattedSeconds() -> String {
        return "\(formatted(value: seconds / 60, numberOfNumbers: 2)):\(formatted(value: seconds % 60, numberOfNumbers: 2))"
    }

    func formattedStatus() -> String {
        return "\(formatted(value: foundWords.count, numberOfNumbers: 2))/\(formatted(value: answers.count, numberOfNumbers: 2))"
    }
}

typealias IsProcessingCallback = (Bool) -> Void

class QuizViewModel: BaseViewModel {
    
    // Variables
    private var timer: Timer?
    private var source: QuizViewModelSource?
    private var service: QuizServiceProtocol = QuizService()
    
    // Callback variables
    var onIsProcessing: IsProcessingCallback?
    
    // State variables
    var isProcessing: Bool = false {
        didSet {
            onIsProcessing?(isProcessing)
        }
    }
    
    override init(withPresenter presenter: UIViewController) {
        super.init(withPresenter: presenter)
        registerNotifications()
    }
    
    init(withPresenter presenter: UIViewController, andService service: QuizServiceProtocol? = nil) {
        super.init(withPresenter: presenter)
        
        if let newService = service {
            self.service = newService
        }
        
        registerNotifications()
    }
    
    func start() {
        isProcessing = true
        
        service.fetchQuiz { [weak self] (response, error) in
            self?.isProcessing = false
            guard let unwrappedSelf = self, !unwrappedSelf.shouldHandleError(withError: error) else { return }
            
            guard let answer = response?.answer else { return }
            self?.source = QuizViewModelSource(foundWords: [],
                                               answers: answer)
            
            NotificationCenter.default.post(name: newAnswerFoundNotification,
                                            object: (unwrappedSelf.source!.formattedStatus(), unwrappedSelf.source!.foundWords))
            
            DispatchQueue.main.async {
                self?.resetTimer()
            }
        }
    }
    
    private func stop() {
        isProcessing = false
        timer?.invalidate()
    }
}

extension QuizViewModel {
    
    private func resetTimer() {
        NotificationCenter.default.post(name: elapsedTimeNotification, object: source!.formattedSeconds())
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.source?.seconds -= 1
            
            if let seconds = self?.source?.seconds,
               let formattedSeconds = self?.source?.formattedSeconds() {
                NotificationCenter.default.post(name: elapsedTimeNotification, object: formattedSeconds)
                
                if seconds == 0 {
                    self?.timer?.invalidate()
                    self?.timeUpAlert()
                }
            }
        })
    }
}

extension QuizViewModel {
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newEntry(notification:)),
                                               name: newEntryNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resetGame),
                                               name: resetGameNotification,
                                               object: nil)
    }
    
    @objc
    private func newEntry(notification: Notification) {
        if let newEntry = notification.object as? String {
            validate(entry: newEntry)
        }
    }

    @objc
    private func resetGame() {
        stop()
        start()
    }

    private func validate(entry: String) {
        if let answers = source?.answers, let foundAnswers = source?.foundWords {
            if answers.count == foundAnswers.count {
                gameFinishedAlert()
            } else if answers.contains(entry),
                !foundAnswers.contains(entry) {
                source?.foundWords.insert(entry, at: 0)
                NotificationCenter.default.post(name: newAnswerFoundNotification,
                                                object: (source!.formattedStatus(), source!.foundWords))
            }
        }
    }
}

extension QuizViewModel {
    
    private func gameFinishedAlert() {
        stop()
        
        let alertController = UIAlertController(title: "Congratulations",
                                                message: "Good job! You found all the answers on time. Keep up with the great work.",
                                                preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Play Again", style: .default) { [weak self] (_) in
            self?.start()
        }
        
        alertController.addAction(action)
        presenter?.present(alertController, animated: true, completion: nil)
    }
    
    private func timeUpAlert() {
        if let source = source {
            stop()
            
            let alertController = UIAlertController(title: "Time finished",
                                                    message: "Sorry, time is up! You got \(source.foundWords.count) out of \(source.answers.count) answers.",
                preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "Try Again", style: .default) { [weak self] (_) in
                self?.start()
            }
            
            alertController.addAction(action)
            presenter?.present(alertController, animated: true, completion: nil)
        }
    }
}
