//
//  Item.swift
//  Todoey
//
//  Created by Dhruvil Patel on 5/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title:String=""
    @objc dynamic var done:Bool=false
    @objc dynamic var dateCreated:Date?
    let parentCategory=LinkingObjects(fromType: Category.self, property: "items") //this means inverse  realtipnship from item to category (ie parent),propery:"item" since let item is defined in Category.swift
    
}
