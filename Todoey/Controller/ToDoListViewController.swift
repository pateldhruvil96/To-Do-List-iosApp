
import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray=[Item]() //this turns array into array of Item objects
    //let defaults = UserDefaults.standard //note that this is not database and for example to access the array then system has to open all the items in the plist. so this affects the efficient of the app.so it is recommended to use only to store small value and not to store large values.ie like storing more no. of values in array.
    let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist") //this is will create your own datafile plist named Item.plist
           
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadItems()
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //this is same as below if else condition this means that it will set opposipte value ! means opposite
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
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        
        let alert=UIAlertController(title: "Add new To Do List", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            let newItem=Item()
            newItem.title=textField.text!
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
    func saveItems(){ //this is done to insert the data
        let encoder=PropertyListEncoder()
            do{
        let data = try encoder.encode(itemArray)//this will encode ie make item array into plist(propertList)
                try data.write(to:dataFilePath!) //this is used to write the data at location self.dataFilePath
            }catch{
                print("Error:\(error)")
            }
            
        
            tableView.reloadData()
    }
    func loadItems() //this is done to take out data
    {
        if let data=try? Data(contentsOf: dataFilePath!)
        {
            let decoder=PropertyListDecoder()
            do{
                itemArray=try decoder.decode([Item].self, from: data) //this will add new  data into itemarray and basically                                                 this will load up when apps loads up
            }catch{
                print("Error:\(error)")
            }
                                                       
        }
    }
}


    

