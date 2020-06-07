//
//  Category.swift
//  Todoey
//
//  Created by Dhruvil Patel on 5/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework
class Category: Object {
   @objc dynamic var name:String=""
    @objc dynamic var colorr:String=UIColor.randomFlat().hexValue()
    
    let items=List<Item>() //means this is forward relationship one to many type
    
}
