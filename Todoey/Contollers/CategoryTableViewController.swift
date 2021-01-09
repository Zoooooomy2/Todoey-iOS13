//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Matt Nutt on 06/01/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray: [Category] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: K.new.category, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.new.buttonCategory, style: .default) { (action) in
            if let text = textField.text {
                if text == "" {
                    print(K.new.emptyField)
                }else {
                    let newCategory = Category(context: self.context)
                    newCategory.name = text
                    newCategory.color = String("red")
                    self.categoryArray.append(newCategory)
                    self.saveData()
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = K.new.placeholderCategory
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.category, for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        cell.backgroundColor = UIColor(named: categoryArray[indexPath.row].color!)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.parentCategory = categoryArray[indexPath.row]
        }
    }

    //MARK: - CRUD: Create, Read, Update & Delete
    
    func fetchData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        //Required for Read
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print(K.error.fetch)
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func saveData() {
        //Required for Create, Update & Delete
        do {
            try context.save()
        }catch{
            print(K.error.save)
            print(error)
        }
        tableView.reloadData()
    }
}
    

