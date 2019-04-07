//
//  Category.swift
//  Todoey
//
//  Created by Pichai Tangtrongsakundee on 7/4/19.
//  Copyright © 2019 Pichai Tangtrongsakundee. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    let items_child = List<Item>()
    
    // Category points toward Items
    // and Items points back to Category (inversed relationship)
    
}
