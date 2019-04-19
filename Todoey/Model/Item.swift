//
//  Item.swift
//  Todoey
//
//  Created by Pichai Tangtrongsakundee on 7/4/19.
//  Copyright © 2019 Pichai Tangtrongsakundee. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {

    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items_child") // Inversed relationship
    
}
