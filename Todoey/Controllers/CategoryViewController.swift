//
//  CategoryViewController.swift
//  Todoey
//
//  Created by D i on 04.10.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    // signed to collection class as Result with category objects
    var categories: Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()
        tableView.rowHeight = 80.0
        
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //nil Coalescing Operator
        return categories?.count ?? 1
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add a new category...", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.tableView.reloadData()
            
            //save to realm
            self.save(category: newCategory)
            
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive) { action in
            print("cancel pressed")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "whatever buddy"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        //present alert
        present(alert, animated: true, completion: nil)
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            //commit changes to realm
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    //from realm
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        //        let request: NSFetchRequest<Category> = Category.fetchRequest()
        //
        //        do {
        //            categories = try context.fetch(request)
        //        } catch {
        //            print("Error fetching data from \(error)")
        //        }
        //
        //        tableView.reloadData()
    }
    
    
    
}

//MARK: - this is a swipeCell delegate methods
extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            if let categoryForDeletion = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting category, \(error)")
                }
               // tableView.reloadData()
            }
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
}






