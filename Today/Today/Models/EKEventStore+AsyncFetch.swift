//
//  EKEventStore+AsyncFetch.swift
//  Today
//
//  Created by Uri on 26/9/25.
//

import Foundation
import EventKit

extension EKEventStore {
    
    // Asynchronous wrapper function that can return reminders inline.
    func reminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
        try await withCheckedThrowingContinuation { continuation in
            fetchReminders(matching: predicate) { reminders in
                if let reminders {
                    continuation.resume(returning: reminders)
                } else {
                    continuation.resume(throwing: TodayError.failedReadingReminders)
                }
            }
        }
    }
}

// withCheckedThrowingContinuation adapts a callback/completion method (fetch reminders) to async / await
