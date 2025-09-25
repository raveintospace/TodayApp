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
    
    /// Present -as a modal- the UI to create a new reminder
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        let reminder = Reminder(title: "", dueDate: Date.now)
        
        // A new VC with the same look as when the user edits an existing reminder
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.addReminder(reminder) // Updates data source
            self?.updateSnapshot()  // Updates UI
            self?.dismiss(animated: true)   // Dismisses the modal
        }
        viewController.isAddingNewReminder = true
        viewController.setEditing(true, animated: false)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd(_:)))
        viewController.navigationItem.title = NSLocalizedString("Add Reminder", comment: "Add Reminder view controller title")
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    /// Dismiss the UI to create a new reminder
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
