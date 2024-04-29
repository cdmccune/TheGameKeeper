//
//  GeneralMocks.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import UIKit
import CoreData
@testable import Whats_The_Score

// MARK: - ViewController

class ViewControllerPresentMock: UIViewController {
    var presentCalledCount = 0
    var presentViewController: UIViewController?
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCalledCount += 1
        presentViewController = viewControllerToPresent
    }
}


// MARK: - Navigation Controller

class NavigationControllerPushMock: UINavigationController {
    var pushViewControllerCount = 0
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.pushedViewController = viewController
        pushViewControllerCount += 1
    }
}

class RootNavigationControllerPushMock: RootNavigationController {
    var pushViewControllerCount = 0
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.pushedViewController = viewController
        pushViewControllerCount += 1
    }
}

class NavigationControllerPopMock: UINavigationController {
    var popViewControllerCount = 0
    
    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCount += 1
        return nil
    }
}


// MARK: - TableView

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


// MARK: - DispatchQueue

class DispatchQueueMainMock: DispatchQueueProtocol {
    
    var asyncAfterCalledCount = 0
    var asyncAfterDelay: CGFloat?
    func asyncAfterWrapper(delay: CGFloat, work: @escaping @convention(block) () -> Void) {
        asyncAfterCalledCount += 1
        asyncAfterDelay = delay
        work()
    }
    
    var asyncCalledCount = 0
    func async(execute work: @escaping @convention(block) () -> Void) {
        asyncCalledCount += 1
        work()
    }
}


// MARK: - Other

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

class UITextFieldDelegateMock: NSObject, UITextFieldDelegate { }

class TabbarControllerMock: UITabBarController {
    var didSelectCalledCount = 0
    var didSelectTabbarItem: UITabBarItem?
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        didSelectCalledCount += 1
        didSelectTabbarItem = item
    }
}


// MARK: - ManagedObjectContext

class NSManagedObjectContextDeleteObjectMock: NSManagedObjectContext {
    
    init() {
        super.init(concurrencyType: NSManagedObjectContextConcurrencyType(rawValue: 0)!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var deleteNSManagedObjects: [NSManagedObject] = []
    override func delete(_ object: NSManagedObject) {
        deleteNSManagedObjects.append(object)
    }
}


    // MARK: - ScoreChangeSettings

extension ScoreChangeSettings {
    static func getStub() -> ScoreChangeSettings {
        return ScoreChangeSettings(player: PlayerMock())
    }
}

// MARK: - EndRoundSettings

extension EndRoundSettings {
    static func getStub(withPlayerCount playerCount: Int) -> EndRoundSettings {
        var endRoundSettings = EndRoundSettings(scoreChangeSettingsArray: [], roundNumber: 0)
        for _ in 0..<playerCount {
            endRoundSettings.scoreChangeSettingsArray.append(ScoreChangeSettings.getStub())
        }
        return endRoundSettings
    }
}

// MARK: - PlayerSettings

extension PlayerSettings {
    static func getStub(name: String = "", icon: PlayerIcon = .alien, id: UUID = UUID()) -> PlayerSettings {
        return PlayerSettings(name: name, icon: icon, id: id)
    }
}


// MARK: - UIButton

class UIButtonSetAttributedUnderlinedTitleWithSubtextMock: UIButton {
    
    var setAttributedUnderlinedTitleWithSubtextTitle: String?
    var setAttributedUnderlinedTitleWithSubtextSubtext: String?
    var setAttributedUnderlinedTitleWithSubtextCalledCount = 0
    override func setAttributedUnderlinedTitleWithSubtext(title: String, subtext: String) {
        setAttributedUnderlinedTitleWithSubtextTitle = title
        setAttributedUnderlinedTitleWithSubtextSubtext = subtext
        setAttributedUnderlinedTitleWithSubtextCalledCount += 1
    }
}

class UIButtonUnderlineButtonForButtonStatesMock: UIButton {
    
    var underlineButtonForButtonStatesTitle: String?
    var underlineButtonForButtonStatesTextSize: CGFloat?
    var underlineButtonForButtonStatesCalledCount = 0
    override func underlineButtonForButtonStates(title: String, withTextSize textSize: CGFloat) {
        underlineButtonForButtonStatesTitle = title
        underlineButtonForButtonStatesTextSize = textSize
        underlineButtonForButtonStatesCalledCount += 1
    }
}

// MARK: - Textfield

class UITextFieldBecomeFirstResponderMock: UITextField {
    var becomeFirstResponderCalledCount = 0
    override func becomeFirstResponder() -> Bool {
        becomeFirstResponderCalledCount += 1
        return true
    }
}


// MARK: - UIView

class UIViewRemoveFromSuperviewMock: UIView {
    var removeFromSuperviewCalledCount = 0
    override func removeFromSuperview() {
        removeFromSuperviewCalledCount += 1
    }
}


// Mark: - PopoverDismissingDelegate

class PopoverDismissingDelegateMock: PopoverDimissingDelegate {
    var maskView: UIView?
    var popoverDismissedCalledCount = 0
    
    func popoverDismissed() {
        popoverDismissedCalledCount += 1
    }
}
