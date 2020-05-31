//
//  Dara.swift
//  Todoey
//
//  Created by Dhruvil Patel on 5/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
class Data: Object {
    @objc dynamic var name:String = "" //means these will dynamically can change the values while the app is running
    @objc dynamic var age:Int=0
}
