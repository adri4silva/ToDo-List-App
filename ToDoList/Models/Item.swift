//
//  Item.swift
//  ToDoList
//
//  Created by Adrián Silva on 10/1/18.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import Foundation

class Item: Codable {
    
    // all the items of an "Codable" class must be a "normal" type i.e. String, Int... not custom type
    var title: String = ""
    var done: Bool = false
    
}
