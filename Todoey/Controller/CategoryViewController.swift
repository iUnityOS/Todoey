//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Muhanad Azzeh on 8/26/18.
//  Copyright © 2018 Prema. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        var tField = UITextField()
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "New Category"
            tField = textField
        }
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let cat = Category(context: self.context)
            cat.name = tField.text
            
            self.categories.append(cat)
            
            self.tableView.reloadData()
            
            self.saveTasks()
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(alertAction)
        alert.addAction(alertCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        performSegue(withIdentifier: "showItems", sender: self)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "category cell", for: indexPath)

        cell.textLabel?.text = categories[indexPath.row].name

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? TodoListViewController {
            
            destinationVC.currentCategory = categories[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    // MARK: - Database methods
    
    func saveTasks() {
        
        do {
            
            try context.save()
            
        } catch {
            
        }
    }
    
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            
            categories = try context.fetch(request)
        } catch {
            
        }
        
        tableView.reloadData()
    }

}
