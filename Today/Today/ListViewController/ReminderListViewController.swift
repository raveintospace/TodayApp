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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        updateSnapshot()
        
        // Assign the data source to the collection view
        collectionView.dataSource = dataSource
    }

    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }

}

