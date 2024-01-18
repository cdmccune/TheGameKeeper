//
//  UITableViewExtensions.swift
//  Whats The Score
//
//  Created by Curt McCune on 1/18/24.
//

import Foundation
import UIKit

// Taken from here: https://stackoverflow.com/questions/12257008/using-long-press-gesture-to-reorder-cells-in-tableview
// Allows tableview to set itself as drag/drop delegate and if it has moveRowAt function, user can drag locally

extension UITableView: UITableViewDragDelegate {
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension UITableView: UITableViewDropDelegate {
    public func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
}
