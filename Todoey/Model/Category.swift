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
    let items_child = List<Item>() // each Category can have several Item objects.
    
    // NOTE: 'Category' class points toward 'Items' in term of List and
    //        Items points back to Category (inversed relationship)
    
}
