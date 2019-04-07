//
//  Data.swift
//  Todoey
//
//  Created by Pichai Tangtrongsakundee on 7/4/19.
//  Copyright © 2019 Pichai Tangtrongsakundee. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
