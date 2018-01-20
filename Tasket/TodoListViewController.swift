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
    
    let todoArray = ["Eat Breakfast", "Clean House", "Create DataSource", "Go To Bed", "Brush Teeth", "Make Pizza", "Scrub Toilet", "Thaw Chicken", "Save The World", "Call Mom", "Renew Tags", "Do Homework", "Watch Netflix", "Be A Hipster", "Drink Water"]
    
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
        cell.textLabel?.text = todoArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleCheckmark(forCell: tableView.cellForRow(at: indexPath)!)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func toggleCheckmark(forCell cell: UITableViewCell) {
        cell.accessoryType = (cell.accessoryType == .checkmark) ? .none : .checkmark
    }
}
