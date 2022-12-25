//
//  Date.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/25/22.
//

import Foundation

extension Date {
    var localizedFormat: String {
        return DateFormatter.localizedFormatter.string(from: self)
    }
}
