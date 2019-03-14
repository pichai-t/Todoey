//
//  ViewController.swift
//  Todoey
//
//  Created by Pichai Tangtrongsakundee on 5/3/19.
//  Copyright © 2019 Pichai Tangtrongsakundee. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]() // To keep information of cell
    var textField = UITextField()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //var defaults = UserDefaults.standard
    
    // Create a Data File Path -- where stores data to physical -- NSCoder
//    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    // 1. WHEN First loading.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //print(dataFilePath)
        
        // Load data from stored data (to "itemArray")
        load_n_Link_itemArrayFromCoreData()
        
//        var item = Item()
//        item.title = "test"
//        itemArray.append(item)
        
          /* Load from UserDefault to ItemArray */
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//           itemArray = items
//        }
    
    }

    //MARK - TableView Delegate Methods - 2 required methods =====
    // When CHECKING Number of rows - *** First time and whenever 'tableView.reloadData()' called ***
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // When LOADING For Each Cell - *** First time and whenever 'tableView.reloadData()' called ***
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath )
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = (item.done == true) ? .checkmark : .none
        
        return cell  // Then for the first time, tableView.reloadData will be automatically called.
    }
    // =============================================================

    // 2. When SELECT ROW - tick or untick.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set 'done' (tick)
         itemArray[indexPath.row].done = !(itemArray[indexPath.row].done)
        
        // Alternative: itemArray[indexPath.row].setValue(true, forKey: "done")
        
        // DELETE from staging and then REMOVE from itemArray.
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        // -------------
        
        saveStagingAreaToCoreData()
        refreshScreen()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK --
    // 3 When Add New Items
    @IBAction func addButtonPressed(_ sender: Any) {

        // 1. Main Alert
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        // 2. Action to add to Alert
        let action = UIAlertAction(title: "Add Item", style: .default) { ( myAction) in
            // code to handle when user selects Add.
     
            // IMPORTANT TO UNDERSTAND HERE
            // Since load_n_Link_itemArrayFromCoreData() has liked 'itemArray[]' to Context.
            // 'item' is linked to 'Item' - which is the 'context' - is the CoreData thing.
            // So, whatever tou do with 'itemArray[]' is kept in Staging area.
            // ============================
            let item = Item(context: self.context)
            item.title = self.textField.text!
            item.done = false
            
            // Append a new item back to 'itemArray'
            self.itemArray.append(item)
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // Save ItemArray to NSCoder, load from NSCoder and refresh screen.
            self.saveStagingAreaToCoreData()
            //self.loadFromNSCoder2ItemArray()
            self.refreshScreen()

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
    
    // Save Data to CoreData
    func saveStagingAreaToCoreData() {
        // Put data into NSCoder
        //   let encoder = PropertyListEncoder()
        do {
            try context.save()
            //    let data = try encoder.encode(itemArray)
            //    try data.write(to: dataFilePath!)
        }
        catch {
            print ("Error saving context: \(error)")
        }
    }
    
    // Load Data from CoreData
    func load_n_Link_itemArrayFromCoreData() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    func refreshScreen() {
        tableView.reloadData() // To call two methods basically;
        // 1. override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2. override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    }

//    func loadFromNSCoder2ItemArray() {
//        // Load data from NSCoder
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            do {
////                let decoder = PropertyListDecoder()
////                itemArray = try decoder.decode([Item].self, from: data)
//            }
//            catch {
//                print("Error in decoding \(error)")
//            }
//        }
//    }
    
}


// Continue with 243

