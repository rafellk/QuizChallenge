//
//  MockedQuizService.swift
//  QuizChallengeTests
//
//  Created by Rafael Lucena on 12/11/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import Foundation
@testable import QuizChallenge

class MockedQuizService: QuizServiceProtocol {
    
    var numberOfItems: Int
    var shouldMockError: Error?
    
    init(withNumberOfItems items: Int, shouldMockError error: Error? = nil) {
        numberOfItems = items
        shouldMockError = error
    }
    
    func fetchQuiz(completion: (QuizServiceCallback<QuizResponse>)?) {
        guard shouldMockError == nil else {
            completion?(nil, shouldMockError)
            return
        }
        
        let response = QuizResponse()
        
        response.question = "Mocked Question"
        response.answer = [String](repeating: "keyword", count: 50)
        
        completion?(response, nil)
    }
}
