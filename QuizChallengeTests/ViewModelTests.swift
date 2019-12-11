//
//  QuizChallengeTests.swift
//  QuizChallengeTests
//
//  Created by Rafael Lucena on 12/11/19.
//  Copyright © 2019 RLMG. All rights reserved.
//

import XCTest
@testable import QuizChallenge

class ViewModelTests: XCTestCase {
    
    var viewModel: QuizViewModel!
    var fakeViewController = UIViewController()

    override func setUp() {
        viewModel = QuizViewModel(withPresenter: fakeViewController)
    }

    override func tearDown() {
        viewModel = nil
    }

    func testInitialState() {
        XCTAssert(viewModel.presenter != nil, "There must be a presenter configured")
        XCTAssert(!viewModel.isProcessing, "It should not be processing")
        XCTAssert(viewModel.onIsProcessing == nil, "OnIsProcessing should be nil")
    }
    
    func testWeakPresenter() {
        viewModel = QuizViewModel(withPresenter: UIViewController())
        XCTAssert(viewModel.presenter == nil, "There mustn't be a presenter configured")
    }
    
    func testStartWithSomeItemsFetched() {
        let numberOfItems = 50
        
        let newWordFoundExpectation = expectation(description: "newWordFound notification needs to reach here")
        let elapsedTimeExpectation = expectation(description: "it should receive an elapsed time notification")
        
        elapsedTimeExpectation.expectedFulfillmentCount = 2
        
        var collectedTimes = [String]()
        let helper = NotificationsHelper()
        
        helper.newWordFoundCallback = { tuple in
            if tuple.0 == "00/\(numberOfItems)" {
                newWordFoundExpectation.fulfill()
            }
        }
        
        helper.elapsedTimeCallback = { time in
            collectedTimes.append(time)
            elapsedTimeExpectation.fulfill()
        }
        
        let service = MockedQuizService(withNumberOfItems: numberOfItems)
        viewModel = QuizViewModel(withPresenter: fakeViewController,
                                  andService: service)
        
        viewModel.start()
        
        waitForExpectations(timeout: 1) { (error) in
            if let theError = error {
                XCTAssert(false, theError.localizedDescription)
                return
            }
            
            XCTAssert(collectedTimes.count == 2, "It should have two entries")
        }
    }

    func testStartAndWaitWordNotification() {
        let numberOfItems = 50
        let newWordFoundExpectation = expectation(description: "newWordFound notification needs to reach here")
        
        newWordFoundExpectation.expectedFulfillmentCount = 2
        let helper = NotificationsHelper()
        
        var collectedWords = [(String, [String])]()
        helper.newWordFoundCallback = { tuple in
            collectedWords.append(tuple)
            newWordFoundExpectation.fulfill()
        }
        
        let service = MockedQuizService(withNumberOfItems: numberOfItems)
        viewModel = QuizViewModel(withPresenter: fakeViewController,
                                  andService: service)
        
        viewModel.start()
        NotificationCenter.default.post(name: newEntryNotification, object: "keyword")
        
        waitForExpectations(timeout: 0) { (error) in
            if let theError = error {
                XCTAssert(false, theError.localizedDescription)
                return
            }
            
            XCTAssert(collectedWords.count == 2, "It shoudld have two entries")
            XCTAssert(collectedWords[0].1.count == 0, "it should contains no found words")
            XCTAssert(collectedWords[1].1.count == 1, "it should contain 1 found word")
        }
    }
    
    func testResetGame() {
        let newWordFoundExpectation = expectation(description: "newWordFound notification needs to reach here")
        newWordFoundExpectation.expectedFulfillmentCount = 2
        
        let helper = NotificationsHelper()
        helper.newWordFoundCallback = { tuple in
            newWordFoundExpectation.fulfill()
        }

        let service = MockedQuizService(withNumberOfItems: 1)
        viewModel = QuizViewModel(withPresenter: fakeViewController,
                                  andService: service)

        viewModel.start()
        NotificationCenter.default.post(name: resetGameNotification, object: nil)
        
        waitForExpectations(timeout: 1) { (error) in
            if let theError = error {
                XCTAssert(false, theError.localizedDescription)
                return
            }
        }
    }
}
