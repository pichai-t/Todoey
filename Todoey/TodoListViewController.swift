//
//  ViewController.swift
//  Todoey
//
//  Created by Pichai Tangtrongsakundee on 5/3/19.
//  Copyright © 2019 Pichai Tangtrongsakundee. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]() // [""]
    var textField = UITextField()
    
    //var defaults = UserDefaults.standard
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    // 1. WHEN First loading.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath)
        
        // Load data from stored data
        loadData()
        
//        var item = Item()
//        item.title = "test"
//        itemArray.append(item)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//           itemArray = items
//        }
    
        
    }

    //MARK - TableView Delegate Methods - 2 required methods
    // When CHECKING Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // When LOADING For Each Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath )
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = (item.done == true) ? .checkmark : .none
        
        return cell
    }

    // 2. When SELECT ROW
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (indexPath.row)
        
        itemArray[indexPath.row].done = !(itemArray[indexPath.row].done)
        
        saveData()
        loadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK --
    // 3 When Add New Items
    @IBAction func addButtonPressed(_ sender: Any) {

        // 1. Main Alert
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        // 2. Action to add to Alert
        let action = UIAlertAction(title: "Add Item", style: .default) { ( myAction) in
            // code to handle when user select Add.
            let item = Item()
            item.title = self.textField.text!
            item.done = false
            
            self.itemArray.append(item)
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveData()
            self.loadData()

        }
        // 3. Add a Text Field to Alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            self.textField = alertTextField
        }
        
        // 4. Add action to Alert
        alert.addAction(action)
        
        // 5. Present "Alert" - with Text Field and Action.
        present(alert, animated: true, completion: nil)

    }
    
    func saveData() {
        // Put data into NSCoder
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print ("Error encoding item array \(error)")
        }
        self.tableView.reloadData()
    }

    func loadData() {
        // Load data from NSCoder
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error in decoding \(error)")
            }
        
        }
    }
    
}


// Continue with 236

