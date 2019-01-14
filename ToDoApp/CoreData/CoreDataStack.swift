//
//  CoreDataStack.swift
//  ToDoApp
//
//  Created by ogya 1 on 14/01/19.
//  Copyright © 2019 ogya 1. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack{
    var container: NSPersistentContainer{
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores { (description, error) in
            guard error == nil else{
                print("Error : \(error!)")
                return
            }
        }
        return container
    }
    
    // Untuk save delete dll
    var managedContext: NSManagedObjectContext{
        return container.viewContext
    }
}
