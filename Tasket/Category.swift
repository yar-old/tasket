//
//  Category.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/22/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let todoItems = List<TodoItem>()
}
