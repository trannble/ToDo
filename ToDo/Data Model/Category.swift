//
//  Category.swift
//  ToDo
//
//  Created by Tran Le on 4/14/20.
//  Copyright © 2020 Tran L. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundHEXColor: String?
    
    //forward relationship
    let tasks = List<Task>()
    //List is a container type (very similar to Arrays). Tasks is an object that holds a List of empty() Task
}
