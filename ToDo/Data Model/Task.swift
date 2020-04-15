//
//  Task.swift
//  ToDo
//
//  Created by Tran Le on 4/14/20.
//  Copyright © 2020 Tran L. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var title: String = " "
    @objc dynamic var done: Bool = false
    
    //inverse relationship:
    var parentCategory = LinkingObjects(fromType: Category.self, property: "tasks")
}
