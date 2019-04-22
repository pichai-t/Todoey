//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Pichai Tangtrongsakundee on 21/4/19.
//  Copyright © 2019 Pichai Tangtrongsakundee. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }

    // TableView DaraSource Methods
    // 1 to return 'number of cell' (this is in sub-class)
    // 2 to return 'a cell object' // CellForRowAt (this is in Super class)
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // CategoryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "JustACell", for: indexPath) as! SwipeTableViewCell
        
        //cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added yet"
        
        cell.delegate = self
        
        return cell
    }
    
    
    // To delete a cell
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("icon deleted")
            self.updateModel(at: indexPath) // to be overridden in SubClass
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update Data Model - to be overridden in SubClass
        
    }

}
