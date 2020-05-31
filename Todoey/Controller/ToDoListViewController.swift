
import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    var itemArray=[Item]() //this turns array into array of Item objects
    //let defaults = UserDefaults.standard //note that this is not database and for example to access the array then system has to open all the items in the plist. so this affects the efficient of the app.so it is recommended to use only to store small value and not to store large values.ie like storing more no. of values in array.
  
   // let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    //this is will create your own datafile plist named Item.plist
    
    var selectedCategory:Category?
    {
        didSet{ //this is run only when selectedcategory gets a value
            loadItems()
        }
    }
           
      let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item=itemArray[indexPath.row]
        cell.textLabel?.text=item.title
        
        //ternary operator:
        //value=condition ? valueOfTrue:valueOfFalse
        cell.accessoryType = item.done ? .checkmark:.none
        
//        if item.done==true
//        {
//            cell.accessoryType  = .checkmark
//        }
//        else
//        {
//            cell.accessoryType  = .none
//        }
        
        
        
        
        return cell
    }
    
    
    //MARK:- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
       // itemArray[indexPath.row].done = !itemArray[indexPath.row].done //this is same as below if else condition this means that it will set opposipte value ! means opposite
        
//        context.delete(itemArray[indexPath.row]) //this is used to delete from Item database table
//        itemArray.remove(at: indexPath.row)       // //this is used to delete from app view mode
        
        
        saveItems() //this is done so that when check then it will convert it into "YES" in "Item.plist"
        
//        if itemArray[indexPath.row].done == false //this is done so that tick mark is not repeated when we scroll down since this is ensure that after pressing tick it will convert bool func to true and so onn
//        {
//            itemArray[indexPath.row].done = true
//        }
//        else
//        {
//            itemArray[indexPath.row].done = false
//        }
        
        
       // tableView.reloadData() //this is used so that after "done" is made true or false this will again call "cellforRow" func and make "checkmark" ie makes tick mark
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
//        {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else
//        {
//
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK:- Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        let alert=UIAlertController(title: "Add new To Do List", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add Item", style: .default) { (action) in
          
            let newItem=Item(context: self.context)
            
            
            newItem.title=textField.text!
            newItem.done=false
            
            newItem.parentCategory=self.selectedCategory
            
            self.itemArray.append(newItem)
           // print(self.itemArray)
           // self.defaults.set(self.itemArray, forKey: "ToDoListArray") //used to store array values in defaults so if we access after app is reopened then will not removed anything
            
            self.saveItems()
            
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Create new item"
            textField=alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Model Manipulation Methods
    func saveItems(){ //this is done to insert the data
        
        do{
           try context.save()
        }catch{
            print("Error:\(error)")
        }
        
      //  let encoder=PropertyListEncoder()
//            do{
//        let data = try encoder.encode(itemArray)//this will encode ie make item array into plist(propertList)
//                try data.write(to:dataFilePath!) //this is used to write the data at location self.dataFilePath
//            }catch{
//                print("Error:\(error)")
//            }
//
            tableView.reloadData()
    }
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil){ //this is done to take out data.
        //Also "with" means it is external parameter name while internal parameter name is "request" which is only used inside this function
        //Also "=" mean that if no parameter is given then it should show "Item.fetchRequest()" as default value we have done this since in line 17 where we have writtten loadItems which dosent have any parameter
       // let request:NSFetchRequest<Item>=Item.fetchRequest() //here "Item" is that database table name
        
        let categoryPredicate=NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!) //see DataModel databse to know why we use "parentCategory".This basically compares that if selected row in CategortyTable viewController matches with parentCategory in database
        
        if let additionalPredicate=predicate //means additionalPredicate is not nil
        {
        request.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate]) //means it combines two condiiton into one using "NSCompoundPredicate"
        }
        else
        {
            request.predicate=categoryPredicate
        }
        
     //   request.predicate=predicate
        do{
       itemArray = try context.fetch(request) //this is basically fetch all the data which is there in item database
        }catch{
            print("Error:\(error)")
        }
        tableView.reloadData()
//        if let data=try? Data(contentsOf: dataFilePath!)
//        {
//            let decoder=PropertyListDecoder()
//            do{
//                itemArray=try decoder.decode([Item].self, from: data) //this will add new  data into itemarray and basically                                                 this will load up when apps loads up
//            }catch{
//                print("Error:\(error)")
//            }
//
//        }
    }
}

//MARK:- Search bar methods
extension ToDoListViewController:UISearchBarDelegate
{
    
        
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
         searchBar.endEditing(true)
        
        let request:NSFetchRequest<Item>=Item.fetchRequest()
        //below we have written steps to  querry means what we want to get back from database.We do this with NSPredicate
        let predicate=NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)// this means that it will search in "title" which "contains" %@(consists of searchBar.text!),which will be saved in predicate.Here "[cd]"means that since this are case and diacritic(means é,á this type of words) sensitive, so in order to make them case insensitive we use [cd]
        //Now below we add our querry to our request
        request.predicate=predicate
        
        let sortDescriptor=NSSortDescriptor(key: "title", ascending: true)//this will simply sort the searched data in ascending order
        request.sortDescriptors=[sortDescriptor]
        
        loadItems(with: request,predicate: predicate)
        //insted to below code we can write in sort the above line of code
        //Now below, run our request and fetch the results
//        do{
//        itemArray = try context.fetch(request) //this is basically fetch all the data which is there in item database
//         }catch{
//             print("Error:\(error)")
//         }
//        tableView.reloadData()
       
//
      
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
//            searchBarSearchButtonClicked(searchBar) //this is used for live searching
//        }
        
    }
   
}




