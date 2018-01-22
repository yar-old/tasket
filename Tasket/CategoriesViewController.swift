//
//  CategoriesViewController.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/21/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table View Data Source Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryItemCell", for: indexPath)


        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    
}
