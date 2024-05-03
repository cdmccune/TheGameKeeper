//
//  GeneralMocks.swift
//  What's The Score
//
//  Created by Curt McCune on 12/30/23.
//

import UIKit
import CoreData
@testable import Whats_The_Score


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


// MARK: - UIView

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


// MARK: - UITextField

class UITextFieldDelegateMock: NSObject, UITextFieldDelegate { }


// MARK: - TabbarController

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


// MARK: - PopoverDismissingDelegate

class PopoverDismissingDelegateMock: PopoverDimissingDelegate {
    var maskView: UIView?
    var popoverDismissedCalledCount = 0
    
    func popoverDismissed() {
        popoverDismissedCalledCount += 1
    }
}
