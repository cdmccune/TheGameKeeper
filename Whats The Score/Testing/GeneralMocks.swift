//
//  GeneralMocks.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import UIKit

class NavigationControllerPushMock: UINavigationController {
    var pushViewControllerCount = 0
    var viewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.viewController = viewController
        pushViewControllerCount += 1
    }
}

class TableViewDelegateMock: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    init(cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
    }
    var cellIdentifier: String
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        return cell
    }
    
}


//class TableView: UICollectionView {
//    init(layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()) {
//        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200), collectionViewLayout: layout)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
