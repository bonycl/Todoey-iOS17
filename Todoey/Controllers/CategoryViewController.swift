//
//  CategoryViewController.swift
//  Todoey
//
//  Created by D i on 04.10.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var itemArray = [Category]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
        
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = itemArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        
        
        return cell
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add a new category...", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "done", style: .default) { action in
            
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            print(self.itemArray)
            self.saveCategories()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "whatever buddy"
            textField = alertTextField
            
            
        }
        alert.addAction(action)
        
        //present alert
        present(alert, animated: true, completion: nil)
        tableView.reloadData()
    }
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
}



//MARK: - TableView Delegate Methods



