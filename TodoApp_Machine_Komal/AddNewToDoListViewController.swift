//
//  AddNewToDoListViewController.swift
//  TodoApp_Machine_Komal
//
//  Created by Mac on 16/02/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import CoreData
class AddNewToDoListViewController: UIViewController {

   let context = AppDelegate().persistentContainer.viewContext
    var delegate : ReloadDataProtocol?
    var updateDelegate : UpdateDataProtocol?
       var update : Bool = false
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addNewTaskText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func didTapBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func didTapSveBtn(_ sender: Any) {
        if addNewTaskText.text == ""{
            let alert = UIAlertController(title: "Alert", message: "Please Enter Any Task", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            guard let task  = self.addNewTaskText.text else{return}
            if update == false{
                let newTask = NSEntityDescription.insertNewObject(forEntityName: "ToDoList", into: self.context) as! ToDoList
                newTask.toDoTask = task
                try! self.context.save()
                delegate?.reloadData()
            }else{
                   self.updateDelegate?.updateData(taskUpdated: task)
            }
           
            self.dismiss(animated: true, completion: nil)
        }
       
    }
    

}
