//
//  ViewController.swift
//  ToDo
//
//  Created by Tran Le on 4/11/20.
//  Copyright © 2020 Tran L. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var todoTasks: Results<Task>?
    
    var selectedCategory: Category? {
        didSet{
            loadTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
        
        loadTasks()
    }
    
    //MARK: - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoTasks?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        if let task = todoTasks?[indexPath.row] {
            cell.textLabel?.text = task.title
            cell.accessoryType = task.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //sets done property (false) to (true) when row selected
        //        todoTasks[indexPath.row].done = !todoTasks[indexPath.row].done
        //
        //        saveTasks()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Tasks
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
            //code for what happens when user clicks "Add Task" button on pop up
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newTask = Task()
                        newTask.title = textField.text!
                        currentCategory.tasks.append(newTask)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated:true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    //to load task: create a request, specify object to fetch, or else fetch default
    func loadTasks() {
        
        taskArray = selectedCategory?.tasks.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //request data from SQLite
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        //specify query (what)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //specify sorting (how)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //fetch result with specific request + reload
        loadTasks(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTasks()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() //no longer selected --> keyboard resigns
                //this is a UI change to move to main thread
            }
        }
    }
}


