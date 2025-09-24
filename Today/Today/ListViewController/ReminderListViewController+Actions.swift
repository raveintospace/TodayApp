//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Uri on 24/9/25.
//

import UIKit

extension ReminderListViewController {
    
    /// Method that calls completeReminder when a user taps the done button in a cell.
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(withId: id)
    }
}
