//
//  ViewController.swift
//  Todoey
//
//  Created by Muhanad Azzeh on 8/5/18.
//  Copyright © 2018 Prema. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var tasks : [Item] = [Item]()
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("tasks.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var currentCategory : Category? {
        
        didSet {
            
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK - Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "task cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].title ?? "No Title!"
        cell.accessoryType = tasks[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tasks[indexPath.row].done = false
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            
            tasks[indexPath.row].done = true
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveTasks()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        var tField = UITextField()
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "New Task"
            tField = textField
        }
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let item = Item(context: self.context)
            item.title = tField.text
            item.done = false
            item.parentCategory = self.currentCategory
            
            self.tasks.append(item)
            
            self.tableView.reloadData()
            
            self.saveTasks()
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(alertAction)
        alert.addAction(alertCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveTasks() {
        
        do {
            
            try context.save()
            
        } catch {
            
        }
    }
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), filter : NSPredicate? = nil) {
        
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", currentCategory!.name!)
        
        if let secPred = filter {
          
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, secPred])
        }
        
        else {
            
            request.predicate = predicate
        }
        
        do {
            
            tasks = try context.fetch(request)
            
        } catch {
            
        }
        
        tableView.reloadData()
    }
}

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print(searchBar.text!)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let filter = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, filter: filter)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        loadData()
        
        DispatchQueue.main.async {
            
            searchBar.resignFirstResponder()
        }
    }
}

