//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Dhruvil Patel on 5/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray=[Category]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    //MARK:- TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category=categoryArray[indexPath.row]
        cell.textLabel?.text=category.name
        return cell
    }
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! ToDoListViewController
        if let indexPath=tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory=categoryArray[indexPath.row]
        }
    }
    
    
    //MARK:- Data Manipulation Methods
    func saveCategory()
    {
        do{
        try context.save()
        }catch{
            print("Error:\(error)")
        }
        tableView.reloadData()
    }
    func loadCategory(with request:NSFetchRequest<Category>=Category.fetchRequest())
    {
        do{
       categoryArray = try context.fetch(request)
        }catch{
            print("Error:\(error)")
        }
        tableView.reloadData()
    }
    
    
    
//MARK:- ADD new categories when button is pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert=UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory=Category(context: self.context)
            newCategory.name=textField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategory()
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Create new category"
            textField=alertTextField
        }
       
        present(alert,animated: true,completion: nil)
    
    }
}


