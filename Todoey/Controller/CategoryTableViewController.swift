//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Dhruvil Patel on 5/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: UITableViewController {
    
     let realm = try! Realm()

    var categoryArray:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.rowHeight=80
        tableView.separatorStyle = .none //this means lines at seach row will dissapear
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor=UIColor(hexString: "1D9BF6") //this is done so thaat when we get back to category table it will again show blue background color in navigational bar
    }
    //MARK:- TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1 //if null then simply return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text=categoryArray?[indexPath.row].name ?? "No Categories added"
        cell.delegate = self //this is done for adding that Swipe functions using cocopods("SwipeTableViewCell") see two line above
        cell.backgroundColor=UIColor(hexString: categoryArray?[indexPath.row].colorr ?? "3F72FF") //this is used for color each row
        
        cell.textLabel?.textColor=ContrastColorOf(cell.backgroundColor!, returnFlat: true) //this is done when if background row color is very dark then this will automatically make text white in colour and vice versa
        
        
       // cell.backgroundColor = UIColor.randomFlat()
        
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
            //newCategory.colorr=cell.backgroundColor
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
//MARK:- SWIPE Cell Delegate Methods
//Below func is used to delete a row my swipping little bit to left and then clicking to delete icon to delete thatrow
extension CategoryTableViewController:SwipeTableViewCellDelegate
{
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            //print("Item deleted")
            if let categoryDeletion=self.categoryArray?[indexPath.row] //this is done since categoryarray is optional so this will check if "self.categoryArray?[indexPath.row]" is not nill then it is named as "categoryDeletion"
            {
                do{
                    try self.realm.write{
                self.realm.delete(categoryDeletion)
                        }
                }
                catch{
                    print("Error:\(error)")
                }
            }
           // tableView.reloadData() we have commented out since if we are using below function then The built-in .destructive, and .destructiveAfterFill expansion styles are configured to automatically perform row deletion when the action handler is invoked (automatic fulfillment)." So there is no use of reloade the data as it is automatically done by below fuction.But if we are not using below func then we have to write this reload line.
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    //Below func is used to delete whole row my simply swipping whole right to left
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
//        options.transitionStyle = .border
        return options
    }
    
    
}
