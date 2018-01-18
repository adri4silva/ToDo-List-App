//
//  Item.swift
//  ToDoList
//
//  Created by Adrián Silva on 18/1/18.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false

    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
