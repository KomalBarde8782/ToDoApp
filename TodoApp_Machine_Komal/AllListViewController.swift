//
//  AllListViewController.swift
//  TodoApp_Machine_Komal
//
//  Created by Mac on 16/02/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import CoreData

class AllListViewController: UIViewController,ReloadDataProtocol,UpdateDataProtocol{
   
    

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var taskTableView: UITableView!
    var tableArray = [ToDoList]()
    let context = AppDelegate().persistentContainer.viewContext
    var index : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        self.fetchDataFromCD()

        // Do any additional setup after loading the view.
    }

    func fetchDataFromCD(){
        let request = NSFetchRequest<ToDoList>.init(entityName: "ToDoList")
        let result = try!context.fetch(request)
        self.tableArray =  result//CoreDataManager.sharedInstance.fetchUserData()
        
    }
    
    func reloadData() {
        print("reloadData delegate method")
        self.fetchDataFromCD()
        self.taskTableView.reloadData()
    }
    
    func updateData(taskUpdated: String) {
        print("index is :\(index)")
        
        if let indexval = index{
            self.tableArray[indexval].setValue(taskUpdated, forKey: "toDoTask")
            try! self.context.save()
            self.taskTableView.reloadData()
        }
       }
    @IBAction func didTapAddBtn(_ sender: Any) {
        var nav = storyboard?.instantiateViewController(withIdentifier: "AddNewToDoListViewController") as! AddNewToDoListViewController
        nav.delegate = self
        self.present(nav, animated: true, completion: nil)
    }
   
    
}

extension AllListViewController : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        var tashObj = tableArray[indexPath.row]
        print("tesy obj is :\(tashObj.toDoTask)")
        cell.textLabel?.text = tashObj.toDoTask
        cell.accessoryType = tashObj.completed ? .checkmark : .none
        
        return cell
    }
    
    //MARK:  update or complete any task
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Alert", message: "Do you want to update the task or complete the task ", preferredStyle: .alert)
        let cell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        if cell.accessoryType != .checkmark{
            let completeAction = UIAlertAction(title: "Complete Task ", style: .default, handler: { action in
                self.taskTableView.deselectRow(at: indexPath, animated: true)
                self.tableArray[indexPath.row].completed = !self.tableArray[indexPath.row].completed
                try! self.context.save()
                self.taskTableView.reloadData()
                
            })
            alert.addAction(completeAction)

        }else{
            // if the task is wrongly marked as complte he can make it in complte
            let IncompleteAction = UIAlertAction(title: "InCompleted Task ", style: .default, handler: { action in
                self.taskTableView.deselectRow(at: indexPath, animated: true)
                self.tableArray[indexPath.row].completed = !self.tableArray[indexPath.row].completed
                try! self.context.save()
                self.taskTableView.reloadData()
                
            })
            alert.addAction(IncompleteAction)
            
        }

        
            let updateAction = UIAlertAction(title: "Update Task", style: .default, handler: { action in
                var nav = self.storyboard?.instantiateViewController(withIdentifier: "AddNewToDoListViewController") as! AddNewToDoListViewController
                       self.index = indexPath.row
                       nav.update = true
                       nav.updateDelegate = self
                       
                       self.present(nav, animated: true, completion: nil)
                
        })
               let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
               })
               alert.addAction(updateAction)
               alert.addAction(cancel)
               DispatchQueue.main.async(execute: {
                   self.present(alert, animated: true)
               })
        
        
    }
   
    
    //MARK: Delete a task
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(tableArray[indexPath.row])
        tableArray.remove(at: indexPath.row)
        try! self.context.save()
        self.taskTableView.reloadData()
    }
}


