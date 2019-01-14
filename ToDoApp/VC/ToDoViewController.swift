//
//  ToDoViewController.swift
//  ToDoApp
//
//  Created by ogya 1 on 14/01/19.
//  Copyright © 2019 ogya 1. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController {
    
    // MARK: - Properties
    
    var managedContext : NSManagedObjectContext!
    var todo : Todo?

    // MARK: Outlest
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segementControl: UISegmentedControl!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottonConstraint : NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(with :)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        textView.becomeFirstResponder()
        
        if let todo = todo{
            textView.text = todo.title
            textView.text = todo.title
            segementControl.selectedSegmentIndex = Int(todo.priority)
        }
    }
    
    // MARK: Actions
    @objc func keyboardWillShow(with notification: Notification){
        
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else{return}
    
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
    
        bottonConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }
    
    

    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        textView.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismissAndResign()
    }
    
    @IBAction func done(_ sender: Any) {
        guard let title = textView.text, !title.isEmpty else {
            return
        }
        
        if let todo = self.todo{
            todo.title = title
            todo.priority = Int16(segementControl.selectedSegmentIndex)
            todo.date = Date()
        } else {
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priority = Int16(segementControl.selectedSegmentIndex)
            todo.date = Date()
        }
        do {
            try managedContext.save()
            dismissAndResign()
        } catch {
            print("Error Saving :\(error) ")
        }
        
        dismiss(animated: true)
    }

}

extension ToDoViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if doneButton.isHidden{
            textView.text.removeAll()
            textView.textColor = .white
            
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
