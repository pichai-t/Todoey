//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pichai Tangtrongsakundee on 17/3/19.
//  Copyright © 2019 Pichai Tangtrongsakundee. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    // To keep information of cell
    var categoryArray : Results<Category>!
    
    var bufferedTextField : UITextField? = nil
    
    // link to context(staging)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 //       loadCat_from_CoreData()
        
        loadCategory_from_Realm()
        
    }
    
    // ========================================
    // Will be call when loading and by tableView.reloadData()
    
    //Mark: - 1 TableView DataSource Methods
    // NumberOfRows In Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // CategoryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        // let cat = categoryArray[indexPath.row]
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added yet"
        return cell
    }
    // ========================================
    
    //Mark: - 2 Data Manipulation Methods; SaveData and LoadData
//    func loadCat_from_CoreData() {
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            catArray = try context.fetch(request) // LINKED 'context' to 'catArray'
//            tableView.reloadData()
//        } catch {
//            print ("Error in Fetch request \(error)")
//        }
//    }

    func loadCategory_from_Realm() {
        // Linking Auto-Update HERE!! - IMPORTANT!!
        categoryArray = realm.objects(Category.self)
    }
    
//    func saveStagingToCoreData() {
//        do {
//            try context.save()
//        }
//        catch {
//            print("Error when Saving Context \(error)")
//        }
//    }
    
    func saveCategory2Realm(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print ("Error when saving Category: \(error)")
        }
        
    }
    
    //Mark: - 3 Add a new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (myAction) in
            
            let newCat = Category()
            newCat.name = self.bufferedTextField!.text!
    
            //self.catArray.append(newCat) // ** Why in Realm, there is no need to append? **
                                           // Since 'var catArray : Results<Category>?', Results object has 'auto-updating' capability
                                           // for any Category() object?
            
            //self.saveStagingToCoreData()
            
            self.saveCategory2Realm(category: newCat)
            self.tableView.reloadData()
        }
        
        // Add Text Field (for the new Category Name)
        alert.addTextField { (textField) in
            textField.placeholder = "Your new Category"
            self.bufferedTextField = textField
        }
        
        // Add "Add Action/button" to Alert
        alert.addAction(action)
        
        present(alert, animated: false)
        
    }
    
    //Mark: - TableView Delegate Methods - when clicking one of the cell.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        // tableView.deselectRow(at: indexPath, animated: true)
        // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        performSegue(withIdentifier: "goToItems", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
}
