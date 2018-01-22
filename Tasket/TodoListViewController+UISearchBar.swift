//
//  TodoListViewController+UISearchBar.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/21/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import UIKit
import CoreData

// MARK: - UISearchBar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

