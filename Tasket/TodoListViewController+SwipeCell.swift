//
//  TodoListViewController+SwipeCell.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/22/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import UIKit
import SwipeCellKit

extension TodoListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        guard let todoItem = todoItems?[indexPath.row] else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.delete(todoItem: todoItem)
        }
        
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func delete(todoItem: TodoItem) {
        do {
            try realm.write {
                realm.delete(todoItem)
            }
        } catch {
            print("Error deleting todoItem from Realm \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}
