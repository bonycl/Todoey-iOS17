//
//  CategoryViewController.swift
//  Todoey
//
//  Created by D i on 04.10.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories = [Category]()
    
    //grab a reference
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
        
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let categories = categories[indexPath.row]
        cell.textLabel?.text = categories.name
        
        
        
        return cell
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add a new category...", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            self.tableView.reloadData()
            
            print(self.categories)
            
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
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories() {
        
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







