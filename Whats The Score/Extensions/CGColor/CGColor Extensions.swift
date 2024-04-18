//
//  CGColor Extensions.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/18/24.
//

import Foundation
import UIKit

extension CGColor {
    func same(as another: CGColor) -> Bool {
        let components = components ?? []
        let anotherComponents = another.components ?? []
        return zip(components, anotherComponents).allSatisfy { abs($0 - $1) < 1e-4 }
    }
}
