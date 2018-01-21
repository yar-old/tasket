//
//  TodoItem.swift
//  Tasket
//
//  Created by Yuri Ramocan on 1/20/18.
//  Copyright © 2018 Yuri Ramocan. All rights reserved.
//

import Foundation

class TodoItem {
    var title: String
    var isFinished: Bool = false
    
    init(title: String) {
        self.title = title
    }
    
    func toggleIsFinished() {
        self.isFinished = self.isFinished ? false : true
    }
}
