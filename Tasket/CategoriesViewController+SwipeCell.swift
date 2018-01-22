//
//  CategoriesViewController+SwipeCell.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/22/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import UIKit
import SwipeCellKit

extension CategoriesViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        guard let category = categories?[indexPath.row] else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.delete(category: category)
        }
        
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func delete(category: Category) {
        do {
            try realm.write {
                realm.delete(category.todoItems)
                realm.delete(category)
            }
        } catch {
            print("Error deleting category from Realm \(error)")
        }
    }
}
