//
//  Item.swift
//  Todoey
//
//  Created by D i on 05.10.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
   @objc dynamic var title: String = ""
   @objc dynamic var done: Bool = false
                                                    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
