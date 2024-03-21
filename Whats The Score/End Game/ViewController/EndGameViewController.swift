//
//  EndGameViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 3/1/24.
//

import UIKit

class EndGameViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
    
    // MARK: - Properties
    
    private lazy var tableViewDelegate = EndGamePlayerTableViewDelegate(viewModel: viewModel)
    private lazy var collectionViewDelegate = EndGamePlayerCollectionViewDelegate(viewModel: viewModel)
    lazy var screenWidth: CGFloat = view.frame.width
    var viewModel: EndGameViewModelProtocol!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegates()
        registerNibs()
        setupViews()
    }
    
    
    // MARK: - Private Functions
    
    private func setDelegates() {
        tableView.delegate = tableViewDelegate
        tableView.dataSource = tableViewDelegate
        collectionView.delegate = collectionViewDelegate
        collectionView.dataSource = collectionViewDelegate
    }
    
    private func registerNibs() {
        tableView.register(UINib(nibName: "EndGamePlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "EndGamePlayerTableViewCell")
        collectionView.register(UINib(nibName: "EndGamePlayerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EndGamePlayerCollectionViewCell")
    }
    
    private func setupViews() {
        let numberOfWinningPlayersCGFloat = CGFloat(viewModel.game.winningPlayers.count)
        let widthOfCollectionViewContent = (128 * numberOfWinningPlayersCGFloat) + (25 * (numberOfWinningPlayersCGFloat - 1))
        
        if widthOfCollectionViewContent > screenWidth {
            self.collectionViewWidth.constant = screenWidth
        } else {
            self.collectionViewWidth.constant = widthOfCollectionViewContent
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func newGameButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let gameSetupViewController = storyboard.instantiateViewController(withIdentifier: "GameSetupViewController") as? GameSetupViewController else {
            fatalError("GameSetupViewController couldn't be found")
        }
        
        navigationController?.viewControllers = [gameSetupViewController]
    }
    
    @IBAction func keepPlayingGameButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let scoreboardViewController = storyboard.instantiateViewController(withIdentifier: "ScoreboardViewController") as? ScoreboardViewController else {
            fatalError("ScoreboardViewController couldn't be found")
        }
        
        let viewModel = ScoreboardViewModel(game: viewModel.game)
        scoreboardViewController.viewModel = viewModel
        
        navigationController?.viewControllers = [scoreboardViewController]
    }
}
