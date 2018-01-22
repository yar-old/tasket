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
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", query)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

