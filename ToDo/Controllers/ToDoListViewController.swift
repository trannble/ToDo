//
//  ViewController.swift
//  ToDo
//
//  Created by Tran Le on 4/11/20.
//  Copyright © 2020 Tran L. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeViewController {
    
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
    
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

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
        
        if let task = todoTasks?[indexPath.row] {
            do {
                try realm.write {
                    task.done = !task.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
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
                        newTask.dateCreated = Date()
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
        
        todoTasks = selectedCategory?.tasks.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe Class
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let deleteTask = todoTasks?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(deleteTask)
                }
            } catch {
                print("Error deleting task, \(error)")
            }
        }
    }
}

//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoTasks = todoTasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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


