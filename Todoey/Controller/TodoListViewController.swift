//
//  ViewController.swift
//  Todoey
//
//  Created by Pichai Tangtrongsakundee on 5/3/19.
//  Copyright © 2019 Pichai Tangtrongsakundee. All rights reserved.
//

import UIKit
import RealmSwift
//import CoreData
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()

    var todoItems : Results<Item>? //[Item]() // To keep information of cell
    var textField = UITextField()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //var defaults = UserDefaults.standard
    
    // Create a Data File Path -- where stores data to physical -- NSCoder
//    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    // 1. WHEN First loading.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Title of Navigation bar as the "selectedCategory.name"

        
       // searchBar.delegate = self
        
        // Load data from stored data (to "itemArray")
//        load_n_Link_itemArrayFromCoreData()
        
        // Do any additional setup after loading the view, typically from a nib.
    
//        var item = Item()
//        item.title = "test"
//        itemArray.append(item)
        
          /* Load from UserDefault to ItemArray */
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//           itemArray = items
//        }
    
    }
    
    // Just before User sees anything on screen
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colorHex = selectedCategory?.catColor  else { fatalError("Error UIColor is nil") }
        title = selectedCategory?.name
        
        updateNavBarSetup(withHexCode: colorHex)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        updateNavBarSetup(withHexCode: "1D9BF6")
        
    }
    
    func updateNavBarSetup(withHexCode colorHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Error Navigation Bar does not exist. ") }
        
        guard let uiColorHex = UIColor(hexString: colorHexCode) else { fatalError("Error UIColor does not exist.") }
        
        // the color of SearchBar background
        searchBar.barTintColor = UIColor(hexString: colorHexCode)
        // the color of NavBar background
        navBar.barTintColor = UIColor(hexString: colorHexCode)
        // Color of Tint (including text and button on top nav bar)
        navBar.tintColor = ContrastColorOf(uiColorHex, returnFlat: true)
        // Color of Text (large)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf( uiColorHex, returnFlat: true)]
        
        
    }
    
    

    //MARK - TableView Delegate Methods - 2 required methods =====
    // When CHECKING Number of rows - *** First time and whenever 'tableView.reloadData()' called ***
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // When LOADING For Each Cell - *** First time and whenever 'tableView.reloadData()' called ***
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath )
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        // get/return 'title' and 'accessorry type' for each cell from Realm
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = (item.done == true) ? .checkmark : .none
           
            if let color = UIColor(hexString: selectedCategory!.catColor)!.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No item added"
        }
    
        return cell  // Then for the first time, tableView.reloadData will be automatically called.
    }
    // =============================================================

    // 2. When SELECT ROW - tick or untick.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set 'done' (tick)
        
        //todoItems![indexPath.row].done = !(todoItems![indexPath.row].done)
        
        // Alternative: itemArray[indexPath.row].setValue(true, forKey: "done")
        
        // DELETE from staging and then REMOVE from itemArray.
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)

        // ---------------
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    // realm.delete(item)
            }
            } catch {
                print("Error saving done status \(error)")
            }
        }

        // saveStagingAreaToCoreData()
        refreshScreen()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // ====================================================
    
    override func updateModel(at indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting Item: \(error)")
            }
            tableView.reloadData()
        }
        
    }
    
    //MARK:  Add a new item
    // 3 When Add New Items
    @IBAction func addButtonPressed(_ sender: Any) {

        // 1. Main Alert
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        // 2. Action to add to Alert
        let action = UIAlertAction(title: "Add Item", style: .default) { ( myAction) in
            // code to handle when user selects Add.
     
            // ***** IMPORTANT TO UNDERSTAND HERE ***** CoreData
            // Since load_n_Link_itemArrayFromCoreData() has liked 'itemArray[]' to Context.
            // 'item' is linked to 'Item' - which is the 'context' - is the CoreData thing.
            // So, whatever you do with 'itemArray[]' is kept in Staging area.
            // =========================================
//            let item = Item(context: self.context)
//
//            item.title = self.textField.text!
//            item.done = false
//
//            // Append a new item back to 'itemArray'
//            self.itemArray.append(item)
//            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
//
//            // Save ItemArray to NSCoder, load from NSCoder and refresh screen.
//            self.saveStagingAreaToCoreData()
//            //self.loadFromNSCoder2ItemArray()
//            self.refreshScreen()

            // ==========================================
            
            if let selectedCat = self.selectedCategory {
                do {
                  try self.realm.write {
                    let newItem = Item()
                    
                    newItem.title = self.textField.text!
                    newItem.done = false
                    //let formatter = DateFormatter()
                    //formatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
                    newItem.dateCreated = Date() // formatter.string(from: Date())
                    
                    selectedCat.items_child.append(newItem)
                    }
                }
                catch {
                    print("Error saving new items \(error)")
                }
            }
        
            self.tableView.reloadData()

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
//    func saveStagingAreaToCoreData() {
//        // Put data into NSCoder
//        //   let encoder = PropertyListEncoder()
//        do {
//            try context.save()
//            //    let data = try encoder.encode(itemArray)
//            //    try data.write(to: dataFilePath!)
//        }
//        catch {
//            print ("Error saving context: \(error)")
//        }
//    }
    
    // Load Data from CoreData
//    func load_n_Link_itemArrayFromCoreData(with request: NSFetchRequest<Item> = Item.fetchRequest() ) {
//
//        //let request : NSFetchRequest<Item> = Item.fetchRequest()
//        do {
//            itemArray = try context.fetch(request)
//            refreshScreen()
//        }
//        catch {
//            print("Error fetching data from context: \(error)")
//        }
//    }
    
    func loadItems() {
        todoItems = selectedCategory?.items_child.sorted(byKeyPath: "title", ascending: true)
    }
    

    func refreshScreen() {
        // To call two methods basically;
        // 1. override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2. override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.reloadData()
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


//MARK - SearchBar
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
//        // create a request object
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        //if (searchBar.text != "") {
//            // set request's predicate (filtering)
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//            request.predicate = predicate
//        //}
//
//        // set Sorting to request's sortDescriptors.
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//
//        // Doing the fetch using 'request' object
//        load_n_Link_itemArrayFromCoreData(with: request)
        
          tableView.reloadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                // Resign as(from) the first corresponder!!
                // Once searchBar had downgraded (not 1st anymore), the keyboard will be disappear.
                searchBar.resignFirstResponder()
            }
            
            tableView.reloadData()

        }
//        if (searchBar.text?.count == 0) {
//            load_n_Link_itemArrayFromCoreData()
//
//            // (A BIT CONFUSED HERE) - Go to main thread (so the code inside will be on another thread)
//            DispatchQueue.main.async {
//               // Resign as(from) the first corresponder!!
//               // Once searchBar had downgraded (not 1st anymore), the keyboard will be disappear.
//               searchBar.resignFirstResponder()
//            }
//
//        }
        
    }

    // Continue 264 - at 12 mins // 22 Apr 2019
    
}
