//
//  ProtocolsForTests.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/23/24.
//

import Foundation
import UIKit

protocol DispatchQueueAsyncProtocol {
    func async(execute work: @escaping @convention(block) () -> Void)
}

protocol DispatchQueueAsyncAfterProtocol {
    func asyncAfter(deadline: DispatchTime, execute work: @escaping @convention(block) () -> Void)
}

protocol DispatchQueueProtocol: DispatchQueueAsyncProtocol & DispatchQueueAsyncAfterProtocol {}

extension DispatchQueue: DispatchQueueProtocol {
    func async(execute work: @escaping @convention(block) () -> Void) {
            async(group: nil, qos: .unspecified, flags: [], execute: work)
        }
    
    func asyncAfter(deadline: DispatchTime, execute work: @escaping @convention(block) () -> Void) {
        asyncAfter(deadline: deadline, qos: .unspecified, flags: [], execute: work)
    }
}


protocol SafeAreaFrame {
    var safeAreaFrame: CGRect { get }
}

extension UIView: SafeAreaFrame {
    @objc var safeAreaFrame: CGRect {
        self.safeAreaLayoutGuide.layoutFrame
    }
}
