//
//  Category.swift
//  ToDoList
//
//  Created by Adrián Silva on 18/1/18.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""

    let items = List<Item>()
}
