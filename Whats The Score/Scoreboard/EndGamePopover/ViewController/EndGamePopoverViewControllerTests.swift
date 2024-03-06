//
//  EndGamePopoverViewControllerTests.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 3/1/24.
//

import XCTest
@testable import Whats_The_Score

final class EndGamePopoverViewControllerTests: XCTestCase {
    
    // MARK: - Setup
    
    var viewController: EndGamePopoverViewController!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "EndGamePopoverViewController") as? EndGamePopoverViewController else {
            fatalError("EndGamePopoverViewController wasn't found")
        }
        self.viewController = viewController
    }
    
    override func tearDown() {
        viewController = nil
    }
    
    
    // MARK: - Initialization
    
    func test_EndGamePopoverViewController_WhenViewLoaded_ShouldHaveNonNilOutlets() {
        // given
        let sut = viewController!
        
        // when
        sut.loadView()
        
        // then
        XCTAssertNotNil(sut.gameOverDescriptionLabel)
    }
    
    
    // MARK: - ViewDidLoad
    
    func test_EndGamePopoverViewController_WhenViewDidLoadCalledBasicGame_ShouldSetDescriptionLabelTextToBlank() {
        // given
        let sut = viewController!
        let game = GameIsEndOfGameMock()
        game.gameType = .basic
        sut.game = game
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.gameOverDescriptionLabel.text, "")
    }
    
    func test_EndGamePopoverViewController_WhenViewDidLoadCalledNotEndGameRoundGameType_ShouldSetDescriptionLabelToYouManuallyEndedTheGame() {
        // given
        let sut = viewController!
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = false
        game.gameType = .round
        
        let currentRound = Int.random(in: 1...10)
        game.currentRound = currentRound
        
        sut.game = game
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.gameOverDescriptionLabel.text, "Do you want to end the game on round \(currentRound)?")
    }
    
    func test_EndGamePopoverViewController_WhenViewDidLoadCalledIsEndGameTrueRoundEndGameType_ShouldSetDescriptionLabelTextToRoundText() {
        // given
        let sut = viewController!
        let numberOfRounds = Int.random(in: 2...10)
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        game.gameType = .round
        game.gameEndType = .round
        game.numberOfRounds = numberOfRounds
        sut.game = game
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then

        XCTAssertEqual(sut.gameOverDescriptionLabel.text, "You completed \(numberOfRounds) rounds")
    }
    
    func test_EndGamePopoverViewController_WhenViewDidLoadCalledIsEndGameTrueScoreEndGameType_ShouldSetDescriptionLabelTextToPlayerNameReachedPoints() {
        // given
        let sut = viewController!
        
        let endingScore = Int.random(in: 2...100)
        let playerName = UUID().uuidString
        let player = Player(name: playerName, position: 0)
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        game.winningPlayers = [player]
        game.endingScore = endingScore
        game.gameType = .round
        game.gameEndType = .score
        sut.game = game
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.gameOverDescriptionLabel.text, playerName + " reached \(endingScore) points")
    }
    
    func test_EndGamePopoverViewController_WhenViewDidLoadCalledIsEndGameTrueScoreEndGameTypeMultiplePlayers_ShouldSetDescriptionLabelTextToMultiplePlayersReachedPoints() {
        // given
        let sut = viewController!
        
        let endingScore = Int.random(in: 2...100)
        let player = Player(name: "", position: 0)
        let game = GameIsEndOfGameMock()
        game.isEndOfGameBool = true
        game.winningPlayers = [player, player]
        game.endingScore = endingScore
        game.gameType = .round
        game.gameEndType = .score
        sut.game = game
        
        // when
        sut.loadView()
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.gameOverDescriptionLabel.text, "Multiple players" + " reached \(endingScore) points")
    }
    
    
    // MARK: - FinishGameButtonTapped
    
    func test_EndGamePopoverViewController_WhenFinishGameButtonTapped_ShouldCallDelegateGoToEndGameScreen() {
        // given
        let sut = viewController!
        let delegateMock = EndGamePopoverDelegateMock()
        sut.delegate = delegateMock
        
        // when
        sut.finishGameButtonTapped(0)
        
        // then
        XCTAssertEqual(delegateMock.goToEndGameScreenCalledCount, 1)
    }
    
    func test_EndGamePopoverViewController_WhenFinishGameTapped_ShouldDismissItself() {
        class EndGamePopoverViewControllerDismissMock: EndGamePopoverViewController {
            var dismissCalledCount = 0
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                dismissCalledCount += 1
            }
        }
        
        // given
        let sut = EndGamePopoverViewControllerDismissMock()
        
        // when
        sut.finishGameButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.dismissCalledCount, 1)
    }
    
    // MARK: - KeepPlayingButtonTapped
    
    func test_EndGamePopoverViewController_WhenKeepPlayingButtonTapped_ShouldCallDelegateShowKeepPlayingPopup() {
        // given
        let sut = viewController!
        let delegateMock = EndGamePopoverDelegateMock()
        sut.delegate = delegateMock
        
        // when
        sut.keepPlayingButtonTapped(0)
        
        // then
        XCTAssertEqual(delegateMock.keepPlayingSelectedCalledCount, 1)
    }
    
    func test_EndGamePopoverViewController_WhenKeepPlayingButtonTapped_ShouldDismissItself() {
        class EndGamePopoverViewControllerDismissMock: EndGamePopoverViewController {
            var dismissCalledCount = 0
            override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
                dismissCalledCount += 1
            }
        }
        
        // given
        let sut = EndGamePopoverViewControllerDismissMock()
        
        // when
        sut.keepPlayingButtonTapped(0)
        
        // then
        XCTAssertEqual(sut.dismissCalledCount, 1)
    }
    
    // MARK: - Classes
    class EndGamePopoverDelegateMock: NSObject, EndGamePopoverDelegate {
        var goToEndGameScreenCalledCount = 0
        func goToEndGameScreen() {
            goToEndGameScreenCalledCount += 1
        }
        
        var keepPlayingSelectedCalledCount = 0
        func keepPlayingSelected() {
            keepPlayingSelectedCalledCount += 1
        }
    }
}
