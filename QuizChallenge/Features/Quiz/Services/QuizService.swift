//
//  QuizService.swift
//  QuizChallenge
//
//  Created by Rafael Lucena on 12/10/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import Foundation

class QuizService: QuizServiceProtocol {
    
    func fetchQuiz(completion: (QuizServiceCallback<QuizResponse>)? = nil) {
        defaultOperation(withEndpoint: "/quiz/1", completion: completion)
    }
}
