//
//  ViewController.swift
//  Todoey
//
//  Created by Muhanad Azzeh on 8/5/18.
//  Copyright © 2018 Prema. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var tasks : [Task] = [Task]()
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("tasks.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    //MARK - Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "task cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].taskTitle ?? "No Title!"
        cell.accessoryType = tasks[indexPath.row].taskStatus ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tasks[indexPath.row].taskStatus = false
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            
            tasks[indexPath.row].taskStatus = true
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
            
            let task = Task(title: tField.text!, isDone: false)
            
            self.tasks.append(task)
            
            self.tableView.reloadData()
            
            self.saveTasks()
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(alertAction)
        alert.addAction(alertCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveTasks() {
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(tasks)
            try data.write(to: dataPath!)
            
        } catch {
            
        }
    }
    
    func loadData() {
        
        if let data = try? Data(contentsOf: dataPath!) {
            
            let decoder = PropertyListDecoder()
            
            do {
                
                tasks = try decoder.decode([Task].self, from: data)
            } catch {
                
            }
        }
        
        
    }
}

