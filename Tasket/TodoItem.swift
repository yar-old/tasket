//
//  TodoItem.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/22/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isFinished: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "todoItems")
}
