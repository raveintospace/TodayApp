//
//  ViewController.swift
//  Today
//
//  Created by Uri on 24/9/25.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
    
    var dataSource: DataSource?
    var reminders: [Reminder] = Reminder.sampleData
    var listStyle: ReminderListStyle = .today
    
    var filteredReminders: [Reminder] {
        return reminders.filter { listStyle.shouldInclude(date: $0.dueDate) }.sorted {
            $0.dueDate < $1.dueDate
        }
    }
    
    let listStyleSegmentedControl = UISegmentedControl(items: [
        ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name
    ])
    
    var headerView: ProgressHeaderView?
    
    // Progress of pending reminders
    var progress: CGFloat {
        let chunkSize = 1.0 / CGFloat(filteredReminders.count)
        let progress = filteredReminders.reduce(0.0) {  // reduce returns the result of combining a sequence's elements
            let chunk = $1.isComplete ? chunkSize : 0
            return $0 + chunk
        }
        return progress
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .todayGradientFutureBegin
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        // Set the cell’s content and appearance
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        // Connect the diffable ("actualitzable") data source to the collection view
        // A diffable data source stores a list of identifiers that represents the identities of the items in the collection view.
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: ProgressHeaderView.elementKind, handler: supplementaryRegistrationHandler)
        dataSource?.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibility label")
        navigationItem.rightBarButtonItem = addButton
        navigationItem.style = .navigator
        
        // Set the highlighted segment
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl
        
        updateSnapshot()
        
        // Assign the data source to the collection view
        collectionView.dataSource = dataSource
    }
    
    // When tapping the cell, it is not selected (false), it navigates to DetailView
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filteredReminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBackground()
    }
    
    // Called when the collection view is about to display the supplementary view
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard elementKind == ProgressHeaderView.elementKind, let progressView = view as? ProgressHeaderView else { return }
        progressView.progress = progress    // assign the calculated progress
    }
    
    // MARK: - Custom methods
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func pushDetailViewForReminder(withId id: Reminder.ID) {
        let reminder = reminder(withId: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.updateReminder(reminder) // update the array of reminders in data source with the edited reminder
            self?.updateSnapshot(reloading: [reminder.id]) // update UI to reflect the edited reminder
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // Generates a swipe action configuration for each item in the list.
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        
        // Retrieve the item identifier from the data source
        guard let indexPath, let id = dataSource?.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
            self?.deleteReminder(withId: id)
            self?.updateSnapshot()
            completion(false)   // As we update the UI, we don't need to animate the cell disappearance
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // Registers the supplementary view (header) and how to configure it
    private func supplementaryRegistrationHandler(progressView: ProgressHeaderView, elementKind: String, indexPath: IndexPath) {
        headerView = progressView
    }
    
    // Builds the background layer
    func refreshBackground() {
        collectionView.backgroundView = nil
        let backgroundView = UIView()
        let gradientLayer = CAGradientLayer.gradientLayer(for: listStyle, in: collectionView.frame)
        backgroundView.layer.addSublayer(gradientLayer)
        collectionView.backgroundView = backgroundView
    }
    
    // Shows errors for the known issues
    private func showError(_ error: Error) {
        let alertTitle = NSLocalizedString("Error", comment: "Error alert title")
        let alert = UIAlertController(title: alertTitle, message: error.localizedDescription, preferredStyle: .alert)
        let actionTitle = NSLocalizedString("OK", comment: "Alert OK button title")
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}

