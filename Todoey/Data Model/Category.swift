//
//  Category.swift
//  Todoey
//
//  Created by Khajornkait Usap on 24/3/18.
//  Copyright © 2018 Khajornkiat Usap. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
