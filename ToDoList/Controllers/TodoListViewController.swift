//
//  ViewController.swift
//  ToDoList
//
//  Created by Adrián Silva on 8/1/18.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 60.0
        tableView.separatorStyle = .none
        loadItems()
    }

    override func viewWillAppear(_ animated: Bool) {

        guard let colourHex = selectedCategory?.colour else { return }
        title = selectedCategory?.name

        updateNavBar(withHexCode: colourHex)

    }

    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "F97F3E")
    }

    //MARK - Navigation Bar Setup

    func updateNavBar(withHexCode colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else { return }
        let color = UIColor(hexString: colourHexCode)
        navBar.barTintColor = color
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        navBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor:UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        ]
        navBar.largeTitleTextAttributes = [
            NSAttributedStringKey.foregroundColor:UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        ]
    }


    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)

        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let everyItem = items?[indexPath.row] {
            cell.textLabel?.text = everyItem.title
            cell.accessoryType = everyItem.done ? .checkmark : .none // True -> .checkmark, False -> .none

            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.item) / CGFloat(items!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
            }


        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK - TablewView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status")
            }

        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user clicks the action button

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                        newItem.dateCreated = Date()
                    }
                } catch {
                    print("Error trying to save on Realm")
                }
            }

            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Create New Item"
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems() {

        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }

    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.items {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion[indexPath.item])
                }
            } catch {
                print("Error deleting item")
            }
        }
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.items = self.items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


