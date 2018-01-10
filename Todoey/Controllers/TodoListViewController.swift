//
//  ViewController.swift
//  Todoey
//
//  Created by Adrián Silva on 8/1/18.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var items = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let array = defaults.array(forKey: "ToDoListArray") as? [Item]{
            items = array
        }
        
        let item1 = Item()
        item1.title = "Find Mike"
        items.append(item1)
        
        let item2 = Item()
        item2.title = "Buy Eggos"
        items.append(item2)
        
        let item3 = Item()
        item3.title = "Destroy Demogorgon"
        items.append(item3)
        
        
        
    }

    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        let everyItem = items[indexPath.row]
        
        cell.textLabel?.text = everyItem.title
        
        cell.accessoryType = everyItem.done ? .checkmark : .none // True -> .checkmark, False -> .none
        
        return cell
    }
    
    //MARK - TablewView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].done = !items[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user clicks the action button
            let newItem = Item()
            newItem.title = textField.text!
            
            self.items.append(newItem)
            
            self.defaults.set(self.items, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Item"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}

