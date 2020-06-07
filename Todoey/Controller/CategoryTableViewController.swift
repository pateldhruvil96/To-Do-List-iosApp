//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Dhruvil Patel on 5/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
     let realm = try! Realm()

    var categoryArray:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    //MARK:- TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1 //if null then simply return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text=categoryArray?[indexPath.row].name ?? "No Categories added"
        return cell
    }
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //so before performing segue this  function
        let destinationVC=segue.destination as! ToDoListViewController  //will be called
        if let indexPath=tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory=categoryArray?[indexPath.row]
        }
    }
    
    
    //MARK:- Data Manipulation Methods
    func save(category:Category)
    {
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error:\(error)")
        }
        tableView.reloadData()
    }
    func loadCategory()
    {
       categoryArray=realm.objects(Category.self) //"Category.self" measn category objects
        
       tableView.reloadData() //this is will call all the "TableView DataSource Methods" again
    }
    
    
    
//MARK:- ADD new categories when button is pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert=UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add", style: .default) { (action) in //this will create "Add" button
            
            let newCategory=Category()
            newCategory.name=textField.text!
            
           // self.categoryArray.append(newCategory) //since "Results" autoupdate so this line is not required
            self.save(category: newCategory)
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Create new category"
            textField=alertTextField
        }
       
        present(alert,animated: true,completion: nil)
    
    }
}


