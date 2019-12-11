//
//  QuizServiceProtocol.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/10/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import Foundation

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
