//
//  Category.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/31/22.
//

import Foundation

struct Category {
    let id: Int
    var selected: Bool = false
    
    var title: String {
        return "Category " + String(self.id)
    }
    
//    static func < ()
}
