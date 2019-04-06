//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pichai Tangtrongsakundee on 17/3/19.
//  Copyright © 2019 Pichai Tangtrongsakundee. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    // To keep information of cell
    var catArray = [Category]()
    var bufferedTextField : UITextField? = nil
    
    // link to context(staging)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCat_from_CoreData()
        
    }
    
    // ========================================
    // Will be call when loading and by tableView.reloadData()
    
    //Mark: - 1 TableView DataSource Methods
    // NumberOfRows In Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // CategoryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let cat = catArray[indexPath.row]
        cell.textLabel?.text = cat.name
        return cell
    }
    // ========================================
    
    //Mark: - 2 Data Manipulation Methods; SaveData and LoadData
    func loadCat_from_CoreData() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            catArray = try context.fetch(request) // LINKED 'context' to 'catArray'
            tableView.reloadData()
        } catch {
            print ("Error in Fetch request \(error)")
        }
    }
    
    func saveStagingToCoreData() {
        do {
            try context.save()
        }
        catch {
            print("Error when Saving Context \(error)")
        }
    }
    
    
    //Mark: - 3 Add a new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (myAction) in
            
            let newCat = Category(context: self.context)
            newCat.name = self.bufferedTextField!.text
            self.catArray.append(newCat)
        
            self.saveStagingToCoreData()
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
        tableView.deselectRow(at: indexPath, animated: true)
        // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    
        
    
    }
}
