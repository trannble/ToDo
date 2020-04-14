//
//  ViewController.swift
//  ToDo
//
//  Created by Tran Le on 4/11/20.
//  Copyright © 2020 Tran L. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var taskArray = [Task]()
    
    var selectedCategory : Category? {
        didSet{
            //going to happen as soon as selectedCategory get set with a value in other controller
            loadTasks()
        }
    }
    
    //creates context (the staging area) from AppDelegate as an object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        searchBar.delegate = self
        
        loadTasks()
    }
    
    //MARK: - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        let task = taskArray[indexPath.row]
        
        cell.textLabel?.text = task.title
        
        cell.accessoryType = task.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //sets done property (false) to (true) when row selected
        taskArray[indexPath.row].done = !taskArray[indexPath.row].done
        
        saveTasks()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Tasks
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
            //code for what happens when user clicks "Add Task" button on pop up
            
            let newTask = Task(context: self.context)
            newTask.title = textField.text!
            newTask.done = false
            newTask.parentCategory = self.selectedCategory
            self.taskArray.append(newTask) //text property of text field will never be nil, only empty String
            
            self.saveTasks()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated:true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    //to load task: create a request, specify object to fetch, or else fetch default
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), with predicate: NSPredicate? = nil) {
        
        //query task list that matches category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        //custom query for each time loadTask
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        
        request.predicate = compoundPredicate
        
        //talk to context and fetch all data in entity
        do {
            taskArray = try context.fetch(request) //returns a NSFetchRequestResult: an array of Tasks from container
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //request data from SQLite
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        
        //specify query
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //specify sorting
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //fetch result with specific request + reload
        loadTasks(with: request, with: predicate)
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


