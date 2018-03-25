//
//  Item.swift
//  Todoey
//
//  Created by Khajornkait Usap on 24/3/18.
//  Copyright © 2018 Khajornkiat Usap. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
