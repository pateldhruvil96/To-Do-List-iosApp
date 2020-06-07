
import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
   // let currentDateTime = Date()
    var todoItems:Results<Item>? //this turns array into array of Item objects
    //let defaults = UserDefaults.standard //note that this is not database and for example to access the array then system has to open all the items in the plist. so this affects the efficient of the app.so it is recommended to use only to store small value and not to store large values.ie like storing more no. of values in array.
  
   // let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    //this is will create your own datafile plist named Item.plist
    
    let realm = try! Realm()
    
    var selectedCategory:Category?
    {
        didSet{ //this is run only when selectedcategory gets a value
            loadItems()
        }
    }
           
     
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
      // loadItems()
        
        
        //print(dataFilePath)
//        let newItem=Item()
//        newItem.title="kem cho"
//        itemArray.append(newItem)
//
//        let newItem1=Item()
//        newItem1.title="supp"
//        itemArray.append(newItem1)
//
//        let newItem2=Item()
//        newItem2.title="hola"
//        itemArray.append(newItem2)
//
//        let newItem3=Item()
//        newItem3.title="all good"
        
//       if let items = defaults.array(forKey: "ToDoListArray") as? [Item]        { //this should not be used since we can only store array,int and small values in "defaults" but we are storing an array of objects which will show error when we add any new item error:"Attempt to set non-property list object"
//           itemArray = items
//       }
        // Do any additional setup after loading the view.
    }
    //MARK:- TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
       if let item=todoItems?[indexPath.row]
       {
        cell.textLabel?.text=item.title
        cell.accessoryType = item.done ? .checkmark:.none
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
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true) //means it will select all the items in the selectedCategory and will show in ascending order
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




