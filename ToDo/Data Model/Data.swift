//
//  Data.swift
//  ToDo
//
//  Created by Tran Le on 4/14/20.
//  Copyright © 2020 Tran L. All rights reserved.
//

import UIKit
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
