//
//  ReminderStore.swift
//  Today
//
//  Created by Uri on 26/9/25.
//

import Foundation
import EventKit

final class ReminderStore {
    static let shared = ReminderStore()
    
    private let ekStore = EKEventStore()
    
    var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .fullAccess
    }
}

/*
 To persist reminders data with a single instace (singleton) of ReminderStore class
 */
