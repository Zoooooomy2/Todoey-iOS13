//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBarBox: UISearchBar!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isRemovingTextWithBackspace = false
    var parentCategory : Category? {
        didSet{
//            if parentCategory?.name != "All" {
//                let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", parentCategory!.name!)
//                fetchData(predicate)
//            }else {
                fetchData()
            //}
        }
    }
    var itemArray: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarBox.searchTextField.delegate = self
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: K.new.item, message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: K.new.buttonItem, style: .default) { (action) in
            if let text = textField.text {
                if text == "" {
                    print(K.new.emptyField)
                }else {
                    
                    let newItem = Item(context: self.context)
                    newItem.parentCategory = self.parentCategory
                    newItem.title = text
                    newItem.isChecked = false
                    self.itemArray.append(newItem)
                    self.saveData()
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = K.new.placeholderItem
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func getAccessoryType(indexPath: IndexPath, isToggling: Bool) -> UITableViewCell.AccessoryType{
        let checked: UITableViewCell.AccessoryType = .checkmark
        let unChecked: UITableViewCell.AccessoryType = .none
        if isToggling == true {
            itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        }
        return itemArray[indexPath.row].isChecked ? checked : unChecked
    }
    
    //MARK: - Table View
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cells.item, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = getAccessoryType(indexPath: indexPath, isToggling: false)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        searchBarBox.resignFirstResponder()
        
//        //To Delete straight away
//        context.delete(items[indexPath.row])
//        items.remove(at: indexPath.row)
        
        //To update tick graphic
        cell?.accessoryType = getAccessoryType(indexPath: indexPath, isToggling: true)
        
        //required regardless
        tableView.deselectRow(at: indexPath, animated: true)
        saveData()
    }
    
    
    
    //MARK: - CRUD: Create, Read, Update & Delete
    
    func fetchData(_ predicate: NSPredicate? = nil) {
        //Required for Read
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", parentCategory!.name!)
        let categorise = parentCategory?.name == "All" ? false : true
        
            if let searchPredicate = predicate {
                if categorise {
                    request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
                }else {
                    request.predicate = searchPredicate
                }
            }else {
                if categorise {
                    request.predicate = categoryPredicate
                }
            }
        
        request.sortDescriptors = [NSSortDescriptor(key: K.search.title, ascending: true)]
        
        do {
            itemArray = try context.fetch(request)
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

//MARK: - Search Bar

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQuery(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.isRemovingTextWithBackspace = (NSString(string: searchBar.text!).replacingCharacters(in: range, with: text).count == 0)
            return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 && !isRemovingTextWithBackspace
        {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            searchBar.endEditing(true)
            fetchData()
        }
        searchQuery(searchBar)
    }
    
    func searchQuery(_ searchBar: UISearchBar) {
        let text = searchBar.text!
        if text != "" {
            let predicate = NSPredicate(format: K.search.format, text)
            fetchData(predicate)
        }else {
            fetchData()
        }
    }
    
}

extension ToDoListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBarBox.resignFirstResponder()
        return true
    }
}

