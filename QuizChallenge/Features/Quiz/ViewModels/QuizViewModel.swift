//
//  QuizViewModel.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/10/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import UIKit

typealias QuizServiceCallback<T> = ((T?, Error?) -> Void) where T: Codable

protocol QuizServiceProtocol: class {
    func fetchQuiz(completion: (QuizServiceCallback<QuizResponse>)?)
}

extension QuizServiceProtocol {
    
    private func baseURLString() -> String {
        return "https://codechallenge.arctouch.com"
    }
    
    private func timeout() -> TimeInterval {
        return 30
    }
    
    func defaultOperation<T>(withEndpoint endpoint: String, completion: QuizServiceCallback<T>? = nil) {
        guard let url = URL(string: "\(baseURLString())\(endpoint)") else { return }
        var timer: Timer!
        var isCancelled = false
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    
                    if !isCancelled {
                        timer.invalidate()
                        completion?(nil, error)
                    }
                    
                    return
            }
            
            do {
                //here dataResponse received from a network request
                let parsedResponse = try JSONDecoder().decode(T.self, from: dataResponse)
                timer.invalidate()
                completion?(parsedResponse, nil)
            } catch let parsingError {
                print("Error", parsingError)
                timer.invalidate()
                completion?(nil, parsingError)
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: timeout(), repeats: false) { (_) in
            // todo: create timeout error
            completion?(nil, nil)
            isCancelled = true
            task.cancel()
        }
        
        task.resume()
    }
}

class QuizService: QuizServiceProtocol {
    
    func fetchQuiz(completion: (QuizServiceCallback<QuizResponse>)? = nil) {
        defaultOperation(withEndpoint: "/quiz/1", completion: completion)
    }
}

// todo: remove this from here
class QuizResponse: Codable {
    var question: String?
    var answer: [String]?
}

// todo: remove this from here
struct QuizModel {
    var seconds: Int
    var numberOfWords: Int
    var foundWords: Int

    // todo: format the correct way
    func formattedSeconds() -> String {
        return "\(seconds / 60):\(seconds % 60)"
    }
}

class BaseViewModel {
    
    private weak var presenter: UIViewController?
    
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


typealias IsProcessingCallback = (Bool) -> Void

class QuizViewModel: BaseViewModel {
    
    // Variables
    private var timer: Timer?
    private var model: QuizModel?
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
    }
    
    init(withPresenter presenter: UIViewController, andService service: QuizServiceProtocol? = nil) {
        super.init(withPresenter: presenter)
        
        if let newService = service {
            self.service = newService
        }
    }
    
    func start() {
        isProcessing = true
        
        service.fetchQuiz { [weak self] (response, error) in
            self?.isProcessing = false
            guard let unwrappedSelf = self, !unwrappedSelf.shouldHandleError(withError: error) else { return }
            
            // todo: do stuff here
            // resetTimer()
        }
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
