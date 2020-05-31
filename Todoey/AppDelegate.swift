import UIKit

import CoreData
import RealmSwift


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {



var window: UIWindow?



func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    print(Realm.Configuration.defaultConfiguration.fileURL)
    
    
    let data=Data()
    data.name="Dhruvil"
    data.age=21
    
    do{
    let realm=try Realm()
        try realm.write{
            realm.add(data)
        }
    }catch{
        print("Error:\(error)")
    }
    
    
    
return true

}



func applicationWillTerminate(_ application: UIApplication) {

self.saveContext()

}



// MARK: - Core Data stack



lazy var persistentContainer: NSPersistentContainer = { //basically this opens up only when it is required and "NSPersistentContainer" is like SQLite database which stores the data.we can also use Excel insted of sqlite hence it is known as persistent



let container = NSPersistentContainer(name: "DataModel") //Note: "DataModel" name should match with DataModel file which is created. so that data can be saved

container.loadPersistentStores(completionHandler: { (storeDescription, error) in

if let error = error as NSError? {

fatalError("Unresolved error \(error), \(error.userInfo)")

}

})

return container

}()



// MARK: - Core Data Saving support



func saveContext () { //saves the data when application gets terminated

let context = persistentContainer.viewContext //context is an area where you can change and update (undo or redo) your data .

if context.hasChanges {

do {

try context.save() //finally when changes are done we will save that data into "NSPersistentContainer"

} catch {

let nserror = error as NSError

fatalError("Unresolved error \(nserror), \(nserror.userInfo)")

}

}

}

}
