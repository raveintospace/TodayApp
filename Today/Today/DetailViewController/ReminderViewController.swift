//
//  ReminderViewController.swift
//  Today
//  This class lays out the list of reminder details and supplies the list with the reminder details data.
//  Created by Uri on 25/9/25.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    
    // Section for section numbers / Row for items in the list
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var reminder: Reminder
    private var dataSource: DataSource?
    
    init(reminder: Reminder) {
        self.reminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        navigationItem.style = .navigator
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateSnapshotForViewing()
    }
    
    // Called when the user taps the Edit / Done button.
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            updateSnapshotForEditing()
        } else {
            updateSnapshotForViewing()
        }
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        
        switch (section, row) {
            
            // Configure the title (header) for every section
        case (_, .header(let title)):
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = title
            cell.contentConfiguration = contentConfiguration
            
            // Configure the rows (_) in the view section
        case (.view, _):
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = text(for: row)
            contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
            contentConfiguration.image = row.image
            cell.contentConfiguration = contentConfiguration
        default:
            fatalError("Unexpected combination of section and row")
        }
        
        cell.tintColor = .todayPrimaryTint
    }
    
    func text(for row: Row) -> String? {
        switch row {
        case .date: return reminder.dueDate.dayText
        case .notes: return reminder.notes
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title: return reminder.title
        default: return nil
        }
    }
    
    private func updateSnapshotForViewing() {
        var snapShot = Snapshot()
        snapShot.appendSections([.view])
        snapShot.appendItems([Row.header(""), Row.title, Row.date, Row.time, Row.notes], toSection: .view)
        dataSource?.apply(snapShot)
    }
    
    private func updateSnapshotForEditing() {
        var snapShot = Snapshot()
        snapShot.appendSections([.title, .date, .notes])
        snapShot.appendItems([.header(Section.title.name)], toSection: .title)
        snapShot.appendItems([.header(Section.date.name)], toSection: .date)
        snapShot.appendItems([.header(Section.notes.name)], toSection: .notes)
        dataSource?.apply(snapShot)
    }
    
    /// Returns the section for a row passed to it.
    // In view mode, all items are displayed in section 0. In editing mode, the title, date, and notes are separated into sections 1, 2 and 3.
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
}
