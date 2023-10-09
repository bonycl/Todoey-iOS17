//
//  Category.swift
//  Todoey
//
//  Created by D i on 05.10.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
//realm object
class Category: Object {
   @objc dynamic var name: String = ""
   @objc dynamic var color: String = ""
    //relationship using realm
    let items = List<Item>()
}

