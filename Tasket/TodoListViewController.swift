//
//  ViewController.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/20/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    // MARK: - Instance Variables
    let realm = try! Realm()
    var todoItems: Results<TodoItem>?
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isFinished ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = todoItems?[indexPath.row] ?? TodoItem()
        item.isFinished = !item.isFinished
        tableView.deselectRow(at: indexPath, animated: true)
        
        save(todoItem: item)
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            guard let text = textField.text else { return }
            if text.isEmpty { return }
            
            guard let currentCategory = self.selectedCategory else { return }

            do {
                try self.realm.write {
                    let newTodoItem = TodoItem()
                    newTodoItem.title = text
                    currentCategory.todoItems.append(newTodoItem)
                }
            } catch {
                print("Error saving to Realm \(error)")
            }
            
            self.tableView.reloadData()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(todoItem: TodoItem) {
        do {
            try realm.write {
                realm.add(todoItem)
            }
        } catch {
            print("Error saving to Realm \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(with predicate: NSPredicate? = nil) {
        if let searchPredicate = predicate {
            todoItems = selectedCategory?.todoItems.filter(searchPredicate).sorted(byKeyPath: "title", ascending: true)
        } else {
            todoItems = selectedCategory?.todoItems.sorted(byKeyPath: "title", ascending: true)
        }
        
        tableView.reloadData()
    }
    
}
