//
//  Category.swift
//  Todoey
//
//  Created by D i on 05.10.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name: String = ""
    
    //relationship using realm
    let items = List<Item>()
}

