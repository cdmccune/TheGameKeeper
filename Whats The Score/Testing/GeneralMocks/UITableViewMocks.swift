//
//  UITableViewMocks.swift
//  Whats The Score Tests
//
//  Created by Curt McCune on 5/3/24.
//

import UIKit
import CoreData
@testable import Whats_The_Score

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

class UITableViewReloadDataMock: UITableView {
    var reloadDataCalledCount = 0
    override func reloadData() {
        reloadDataCalledCount += 1
    }
}

class UITableViewReloadRowsMock: UITableView {
    var reloadRowsCalledCount = 0
    var reloadRowsIndexPathArray: [IndexPath]?
    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        reloadRowsCalledCount += 1
        reloadRowsIndexPathArray = indexPaths
    }
}

class UITableViewRegisterMock: UITableView {
    var registerCellReuseIdentifiers: [String] = []
    override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        registerCellReuseIdentifiers.append(identifier)
    }
    
    var registerHeaderFooterIdentifier: String?
    override func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String) {
        registerHeaderFooterIdentifier = identifier
    }
}
