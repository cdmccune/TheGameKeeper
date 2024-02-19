//
//  GeneralMocks.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import UIKit
@testable import Whats_The_Score

class NavigationControllerPushMock: UINavigationController {
    var pushViewControllerCount = 0
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.pushedViewController = viewController
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

class DispatchQueueMainMock: DispatchQueueProtocol {
    
    var asyncAfterCalledCount = 0
    func asyncAfter(deadline: DispatchTime, execute work: @escaping @convention(block) () -> Void) {
        asyncAfterCalledCount += 1
        work()
    }
    
    var asyncCalledCount = 0
    func async(execute work: @escaping @convention(block) () -> Void) {
        asyncCalledCount += 1
        work()
    }
}


class UITableViewReloadDataMock: UITableView {
    var reloadDataCalledCount = 0
    override func reloadData() {
        reloadDataCalledCount += 1
    }
}

class UIViewSafeAreaLayoutFrameMock: UIView {
    init(safeAreaFrame: CGRect) {
        self.privateSafeAreaFrame = safeAreaFrame
        super.init(frame: safeAreaFrame)
    }
    private var privateSafeAreaFrame: CGRect
    override var safeAreaFrame: CGRect {
        privateSafeAreaFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class UIViewBecomeFirstResponderMock: UIView {
    var becomeFirstResponderCalledCount = 0
    override func becomeFirstResponder() -> Bool {
        self.becomeFirstResponderCalledCount += 1
        return true
    }
}
