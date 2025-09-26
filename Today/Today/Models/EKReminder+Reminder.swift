//
//  EKReminder+Reminder.swift
//  Today
//
//  Created by Uri on 26/9/25.
//

import Foundation
import EventKit

extension EKReminder {
    
    // Update an EKReminder after editing it as a Reminder
    func update(using reminder: Reminder, in store: EKEventStore) {
        title = reminder.title
        notes = reminder.notes
        isCompleted = reminder.isComplete
        calendar = store.defaultCalendarForNewReminders()
        
        // Handle EventKit alarms system, remove the unnecessary and only use the one set with Today
        alarms?.forEach { alarm in
            guard let absoluteDate = alarm.absoluteDate else { return }
            let comparison = Locale.current.calendar.compare(
                reminder.dueDate, to: absoluteDate, toGranularity: .minute
            )
            if comparison != .orderedSame {
                removeAlarm(alarm)
            }
        }
        if !hasAlarms {
            addAlarm(EKAlarm(absoluteDate: reminder.dueDate)) // add an alarm if there's none
        }
    }
}
