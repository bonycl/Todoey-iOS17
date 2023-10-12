//
//  CategoryViewController.swift
//  Todoey
//
//  Created by D i on 04.10.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeViewController {
    
    let realm = try! Realm()
    // signed to collection class as Result with category objects
    var categories: Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategories()
        tableView.separatorStyle = .singleLine
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        navBar.backgroundColor = UIColor.flatPowderBlue()
        //navBar.tintColor = ContrastColorOf(, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor.flatPowderBlue(), returnFlat: true)]
        navBar.topItem?.rightBarButtonItem?.tintColor =  ContrastColorOf(UIColor.flatPowderBlue(), returnFlat: true)
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //nil Coalescing Operator
        return categories?.count ?? 1
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add a new category...", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //newCategory.color = UIColor.randomFlat().hexValue()
            newCategory.color = UIColor.flatPowderBlue().hexValue()
           // newCategory.color = UIColor(gradientStyle: UIGradientStyle.topToBottom, withFrame: .infinite, andColors: [UIColor.flatPowderBlue()]).hexValue()
           
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
        
        tableView.reloadData()
        
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
       
    }
    //MARK: - delete method from swipe
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
}




