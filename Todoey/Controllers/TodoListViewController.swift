//
//  ViewController.swift
//  Todoey
//
//  Created by Gabriel Del VIllar on 11/3/18.
//  Copyright © 2018 gdelvillar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  
  var itemArray = [Item]()
  
  let defaults = UserDefaults.standard
  
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

  override func viewDidLoad() {
    super.viewDidLoad()
    
  loadItems()
    
//    if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//      itemArray = items
//    }
  }
  
  //MARK - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
    let item = itemArray[indexPath.row]
    
    cell.textLabel?.text = item.title
    
    cell.accessoryType = item.done ? .checkmark : .none
    
    return cell
  }
  
  //MARK - Tableview Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    saveItems()
    tableView.reloadData()
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  //MARK - Add New Items
  
  @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // what will happen once the user clicks the add itme button on our UIAlert
      
      let newItem = Item()
      newItem.title = textField.text!
      
      self.itemArray.append(newItem)
      
      self.saveItems()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
      
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  //MARK - Model Manupulation Methods
  
  func saveItems() {
    let encoder = PropertyListEncoder()
    
    do{
      let data = try encoder.encode(self.itemArray)
      try data.write(to: self.dataFilePath!)
    } catch {
      print("Error encoding itme array, \(error)")
    }
    
    self.tableView.reloadData()
    
  }
  
  func loadItems(){
    if let data = try? Data(contentsOf: dataFilePath!) {
      let decoder = PropertyListDecoder()
      do {
      itemArray = try decoder.decode([Item].self, from: data)
      } catch {
        print("Error decoding item array, \(error)")
      }
      
    }
    
    
  }
}
