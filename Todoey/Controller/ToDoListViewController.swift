
import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ToDoListViewController: UITableViewController {
   // let currentDateTime = Date()
    var todoItems:Results<Item>? //this turns array into array of Item objects
    //let defaults = UserDefaults.standard //note that this is not database and for example to access the array then system has to open all the items in the plist. so this affects the efficient of the app.so it is recommended to use only to store small value and not to store large values.ie like storing more no. of values in array.
  
   // let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    //this is will create your own datafile plist named Item.plist
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory:Category?
    {
        didSet{ //this is run only when selectedcategory gets a value
            loadItems()
        }
    }
           
     
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
         tableView.rowHeight=80
        

    }
    override func viewWillAppear(_ animated: Bool) { //this is called after viewdid load and just before users sees the screen .We have to create this as below code wont work in view didload as navigationl bar is not created yet at viewdidload so after viewdidload is created after which navigationbar is created after all this we will call below code
        
        navigationController?.navigationBar.backgroundColor=UIColor(hexString: selectedCategory!.colorr) //this make the navigational bar to the same as the category selected
        navigationController?.navigationBar.tintColor=ContrastColorOf((navigationController?.navigationBar.backgroundColor)!, returnFlat: true) //this makes backbutton contrast with current background colour(same as 59 line)
        navigationController?.navigationBar.largeTitleTextAttributes=[NSAttributedString.Key.foregroundColor:ContrastColorOf((navigationController?.navigationBar.backgroundColor)!, returnFlat: true)] //this is done for Title text in navigation bar ie Home,Work etc in todolist page
        
        
        title=selectedCategory?.name //this is done so that it will show name of the selected category
        searchBar.barTintColor=UIColor(hexString: selectedCategory!.colorr) //makes searchbar same color as list items
        searchBar.searchTextField.backgroundColor=FlatWhite() //this is to make searchbar text field white
        
    }
    //MARK:- TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        
       if let item=todoItems?[indexPath.row]
       {
        cell.textLabel?.text=item.title
        
        if let coloour=UIColor(hexString: selectedCategory!.colorr)?.darken(byPercentage: //this is used to get gradient colors at each row ,here "?" means "optionally chain" means if not nill then proced further
            CGFloat(indexPath.row)*0.8/CGFloat(todoItems!.count)) //note that if we write this Cgfloat(indexPath.row/todoItems!.count) then it wil show error as whole no by whole no will give whle no as output .But if ie 1/10 it should give float value so we have written this way
            {
                cell.backgroundColor=coloour
                cell.textLabel?.textColor=ContrastColorOf(coloour, returnFlat: true) //this will change the text colour depending on the background color of row means if background color of row is dark it makes text white in colour
            }
        
        
        
        
        cell.accessoryType = item.done ? .checkmark:.none
        cell.delegate = self
        
        }
        else
       {
        cell.textLabel?.text="No Items added"
        }
        
        
        
        return cell
    }
    
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item=todoItems?[indexPath.row] //means if todoitem[...] (this is like array)is not nill then store it in "item"
        {
            do{
           try realm.write{
               item.done = !item.done //this means that if it was true then make it false.Means simply make opposite to it
            //realm.delete(item) this is used to deleted that selected row
            }
            }catch{
                print("Error:\(error)")
            }
        }
        tableView.reloadData() //this is will call all the "TableView DataSource Methods" again
        tableView.deselectRow(at: indexPath, animated: true)
      
    }
    //MARK:- Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        let alert=UIAlertController(title: "Add new To Do List", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory=self.selectedCategory//this is done to check weather selectedCategory is nill or not.So if not nill then it is names as "currentCategory"
            {
                do{
                    try self.realm.write{ //this method is done to save them
                    let newItem=Item()
                    newItem.title=textField.text!
                    newItem.dateCreated=Date()
                    currentCategory.items.append(newItem) //.items as in Category.swift "items" is present
                    }
                }catch{
                    print("Error:\(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Create new item"
            textField=alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Model Manipulation Methods

    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true) //means it will select all the items in the selectedCategory and will show in ascending order
        tableView.reloadData()

    }
}

//MARK:- Search bar methods
extension ToDoListViewController:UISearchBarDelegate
{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

         searchBar.endEditing(true) //this is simply dissmiss the keyboard when you press search button in keyboard

        todoItems=todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false) //cd means that it will ignore capital and letters like á,č etc.
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0
        {
            loadItems()
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()//means it will deselect the selection thing ie remove search bar cursor and keyboard
            }
        }

//        else
//        {
//            searchBarSearchButtonClicked(searchBar) //this is used for live searchingg
//        }

    }

}

//MARK:- SWIPE Cell Delegate Methods
//Below func is used to delete a row my swipping little bit to left and then clicking to delete icon to delete thatrow
extension ToDoListViewController:SwipeTableViewCellDelegate
{
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            //print("Item deleted")
            if let todolistDeletion=self.todoItems?[indexPath.row] //this is done since categoryarray is optional so this will check if "self.categoryArray?[indexPath.row]" is not nill then it is named as "categoryDeletion"
            {
                do{
                    try self.realm.write{
                self.realm.delete(todolistDeletion)
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



