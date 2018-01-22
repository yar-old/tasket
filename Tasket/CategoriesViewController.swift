//
//  CategoriesViewController.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/21/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UITableViewController {
    
    // MARK: - Instance Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
    // MARK: - View Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = categoryArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItemCell", for: indexPath)
        cell.textLabel?.text = item.name

        return cell
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTodoItems" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let destinationVC = segue.destination as! TodoListViewController
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            guard let text = textField.text else { return }
            if text.isEmpty { return }
            
            let newCategory = Category(context: self.context)
            newCategory.name = text
            
            self.categoryArray.append(newCategory)
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
