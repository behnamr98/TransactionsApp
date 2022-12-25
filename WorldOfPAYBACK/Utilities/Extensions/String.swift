//
//  String.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/25/22.
//

import Foundation

extension String {
    var date: Date {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self) ?? Date()
    }
}
