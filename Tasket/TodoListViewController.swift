//
//  ViewController.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/20/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    // MARK: - Instance Variables
    
    var todoArray = ["Eat Breakfast", "Clean House", "Create DataSource", "Go To Bed", "Brush Teeth", "Make Pizza", "Scrub Toilet", "Thaw Chicken", "Save The World", "Call Mom", "Renew Tags", "Do Homework", "Watch Netflix", "Be A Hipster", "Drink Water", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"].map { (item) -> TodoItem in
        return TodoItem(title: item)
    }
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = todoArray[indexPath.row].title
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoArray[indexPath.row].toggleIsFinished()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            guard let text = textField.text else { return }
            if text.isEmpty { return }
            
            let newTodoItem = TodoItem(title: text)
            
            self.todoArray.append(newTodoItem)
            
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
