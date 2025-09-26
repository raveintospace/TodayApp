//
//  Reminder+EKReminder.swift
//  Today
//
//  Created by Uri on 26/9/25.
//

import Foundation
import EventKit

// Convert import EKReminder to Reminder

extension Reminder {
    init(with ekReminder: EKReminder) throws {
        guard let dueDate = ekReminder.alarms?.first?.absoluteDate else {
            throw TodayError.reminderHasNoDueDate
        }
        id = ekReminder.calendarItemIdentifier
        title = ekReminder.title
        self.dueDate = dueDate
        notes = ekReminder.notes
        isComplete = ekReminder.isCompleted
    }
}
