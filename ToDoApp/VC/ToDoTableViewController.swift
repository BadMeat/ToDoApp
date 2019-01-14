//
//  ToDoTableViewController.swift
//  ToDoApp
//
//  Created by ogya 1 on 14/01/19.
//  Copyright © 2019 ogya 1. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {

    // MARK: - Properties
    
    var resultController : NSFetchedResultsController<Todo>!
    let coreDataStack = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Request
        let request : NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        
        // Init
        request.sortDescriptors = [sortDescriptors]
        resultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        resultController.delegate = self
        // Fetch
        do{
            try resultController.performFetch()
        }catch{
            print("Perform fetch error : \(error)")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        let todo = resultController.object(at: indexPath)
        cell.textLabel?.text = todo.title

        // Configure the cell...

        return cell
    }
    
    // MARK: - Table View Delegate
    // hapus data dengan swipre
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            // TODO : Delete Todo
            let todo = self.resultController.object(at: indexPath)
            self.resultController.managedObjectContext.delete(todo)
            do{
                try self.resultController.managedObjectContext.save()
                completion(true)
            }catch{
                print("delete failed: \(error)")
                completion(false)
            }
        }
        action.image = #imageLiteral(resourceName: "delete_01")
        action.backgroundColor = .red
       return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            let todo = self.resultController.object(at: indexPath)
            self.resultController.managedObjectContext.delete(todo)
            do{
                try self.resultController.managedObjectContext.save()
                completion(true)
            }catch{
                print("delete failed: \(error)")
                completion(false)
            }
        }
        action.image = #imageLiteral(resourceName: "search")
        action.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowAddTodo", sender: tableView.cellForRow(at: indexPath))
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? ToDoViewController{
            vc.managedContext = resultController.managedObjectContext
        }
        
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? ToDoViewController{
            vc.managedContext = resultController.managedObjectContext
            if let indexPath = tableView.indexPath(for: cell){
                let todo = resultController.object(at: indexPath)
                vc.todo = todo
            }
        }
    }
 

}

extension ToDoTableViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                let todo = resultController.object(at: indexPath)
                cell.textLabel?.text = todo.title
            }
        default:
            break
        }
    }
}
