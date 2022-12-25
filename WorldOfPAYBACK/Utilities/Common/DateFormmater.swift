//
//  DateFormmater.swift
//  WorldOfPAYBACK
//
//  Created by Behnam on 12/25/22.
//

import Foundation

extension DateFormatter {
    
    static var localizedFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }
    
}
