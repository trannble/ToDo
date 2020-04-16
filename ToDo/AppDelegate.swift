//
//  AppDelegate.swift
//  ToDo
//
//  Created by Tran Le on 4/11/20.
//  Copyright © 2020 Tran L. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm() //initialize new Realm "container"
        }
        catch {
            print("Error initializing new realm, \(error)")
        }
        
        return true
    }
    
}



