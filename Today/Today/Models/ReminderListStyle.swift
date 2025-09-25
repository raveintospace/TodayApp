//
//  ReminderListStyle.swift
//  Today
//
//  Created by Uri on 25/9/25.
//

import Foundation

enum ReminderListStyle: Int {
    case today      // rawValue is 0
    case future     // rawValue is 1
    case all        // rawValue is 2
    
    var name: String {
        switch self {
        case .today: return NSLocalizedString("Today", comment: "Today style name")
        case .future: return NSLocalizedString("Future", comment: "Future style name")
        case .all: return NSLocalizedString("All", comment: "All style name")
        }
    }
    
    func shouldInclude(date: Date) -> Bool {
        let isInToday = Locale.current.calendar.isDateInToday(date)
        
        switch self {
        case .today: return isInToday
        case .future: return (date > Date.now) && !isInToday
        case .all: return true
        }
    }
}
