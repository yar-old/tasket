//
//  ViewController.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/20/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    // MARK: - Instance Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todoArray = [TodoItem]()
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
        return todoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = todoArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isFinished ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = todoArray[indexPath.row]
        item.isFinished = !item.isFinished
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveData()
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            guard let text = textField.text else { return }
            if text.isEmpty { return }
            
            let newTodoItem = TodoItem(context: self.context)
            newTodoItem.title = text
            newTodoItem.isFinished = false
            newTodoItem.parentCategory = self.selectedCategory
            
            self.todoArray.append(newTodoItem)
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        
        guard let categoryName = selectedCategory?.name else { return }
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName)
        
        if let addditionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addditionalPredicate])
        } else {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate])
        }
        
        do {
            todoArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}
