//
//  ViewController.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/20/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    // MARK: - Instance Variables
    let realm = try! Realm()
    var todoItems: Results<TodoItem>?
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let category = selectedCategory else { fatalError("Category does not exist.") }
        guard let categoryColor = UIColor(hexString: category.color) else { fatalError("Category color does not exist.") }
        
        updateNavbar(withHexCode: category.color)
        
        searchBar.barTintColor = categoryColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetNavbar()
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isFinished ? .checkmark : .none
            
            guard let categoryColor = UIColor(hexString: selectedCategory?.color ?? UIColor.flatSkyBlue.hexValue()) else { return cell }
            guard let darkenColor = categoryColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) else { return cell }
            
            cell.backgroundColor = darkenColor
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: darkenColor, isFlat: true)
        } else {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.isFinished = !item.isFinished
                }
            } catch {
                print("Error saving isFinished status to Realm \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
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
                    newTodoItem.dateCreated = Date()
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
    
    // MARK: - UI Manipulation Methods
    
    override func configureTableView() {
        super.configureTableView()
        self.title = selectedCategory?.name
    }
    
    func updateNavbar(withHexCode colorHexCode: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        guard let categoryColor = UIColor(hexString: colorHexCode) else { fatalError("Category color does not exist.") }
        
        navBar.barTintColor = categoryColor
        navBar.tintColor = ContrastColorOf(categoryColor, returnFlat: true)
        
        if #available(iOS 11.0, *) {
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(categoryColor, returnFlat: true)]
        } else {
            navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(categoryColor, returnFlat: true)]
        }
    }
    
    func resetNavbar() {
        guard let originalColor = UIColor(hexString: "1D9BF6") else { fatalError("'Original Color' does not exist.") }
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        
        let contrastColor = ContrastColorOf(originalColor, returnFlat: true)
        
        navBar.barTintColor = originalColor
        navBar.tintColor = contrastColor
        
        if #available(iOS 11.0, *) {
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: contrastColor]
        } else {
            navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: contrastColor]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
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
    
    func loadData() {
        todoItems = selectedCategory?.todoItems.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        guard let todoItem = todoItems?[indexPath.row] else { return }
        delete(todoItem: todoItem)
    }
    
    func delete(todoItem: TodoItem) {
        do {
            try realm.write {
                realm.delete(todoItem)
            }
        } catch {
            print("Error deleting todoItem from Realm \(error)")
        }
    }
    
}
