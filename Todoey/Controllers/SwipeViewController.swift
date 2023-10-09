//
//  SwipeViewController.swift
//  Todoey
//
//  Created by D i on 09.10.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - tableView dataSource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    //MARK: - swipeCell delegate methods moved from cat vc.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
            
            print("delete_cell")
            
        }
        
        // customise the action appearance
        deleteAction.image = UIImage(named: "delete-Icon")
        
        return [deleteAction]
    }
    //long swipeDeleting method
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        
        print("item deleted from superClass")
    }
}
