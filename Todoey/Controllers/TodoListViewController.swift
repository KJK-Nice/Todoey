//
//  ViewController.swift
//  Todoey
//
//  Created by Khajornkait Usap on 10/3/18.
//  Copyright © 2018 Khajornkiat Usap. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Ternary Operation ==>
            // value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            //        if item.done == true {
            //            cell.accessoryType = .checkmark
            //        } else {
            //            cell.accessoryType = .none
            //        }
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        
//                        print("Hey it's time!, \(newItem)")
                    }
                } catch {
                    print("Error saving context \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Munupulation Methods
    
    func  loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar methods

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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

