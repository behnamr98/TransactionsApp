//
//  Category.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/31/22.
//

import Foundation

struct Category {
    let id: Int
    var isSelected: Bool = true
    
    var title: String {
        return "Category " + String(self.id)
    }
}

extension Category {
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs.id > rhs.id
    }
}

extension Category: Hashable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
