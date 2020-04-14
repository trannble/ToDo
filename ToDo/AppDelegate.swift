//
//  AppDelegate.swift
//  ToDo
//
//  Created by Tran Le on 4/11/20.
//  Copyright © 2020 Tran L. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    // lazy var = memory benefit (only called when needed)
    lazy var persistentContainer: NSPersistentContainer = { //creates a SQLite container called NSPersistentContainer, where all data is stored. Can use different types of persistentContainer other than SQLite (ie XML)
        
        // creates the container
        let container = NSPersistentContainer(name: "DataModel")
        
        //loads container
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            //returns error if fail
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        //return container if successful --> becomes value of persistentContainer var
        return container
        //can access persistentContainer inside other classes to save data into SQLite database
    }()
    
    // MARK: - Core Data Saving support
    
    // provides support to saving data when app terminates
    func saveContext () {
        
        //create a context, an area to edit data (like a staging area)
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                //permanently save data to persistentContainer once happy with edit in context
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

