//
//  PlayerIconSelectionViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation
import UIKit

class PlayerIconSelectionViewController: UIViewController, Storyboarded {
    
    // MARK: - Properties
    
    var viewModel: PlayerIconSelectionViewModelProtocol?
    lazy var collectionViewDelegate = PlayerIconSelectionCollectionViewDelegateDatasource(viewModel: viewModel)
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = collectionViewDelegate
        collectionView.dataSource = collectionViewDelegate
        collectionView.register(UINib(nibName: "PlayerIconSelectionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayerIconSelectionCollectionViewCell")
        
        viewModel?.shouldDismiss.valueChanged = { [weak self] shouldChange in
            guard shouldChange ?? false else { return }
            self?.dismiss(animated: true)
        }
    }
}
