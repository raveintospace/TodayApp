//
//  ReminderViewController+Row.swift
//  Today
//
//  Created by Uri on 25/9/25.
//

import UIKit

extension ReminderViewController {
    nonisolated enum Row: Hashable, Sendable {
        case header(String)
        case date
        case notes
        case time
        case title
        
        var imageName: String? {
            switch self {
            case .date: return "calendar.circle"
            case .notes: return "square.and.pencil"
            case .time: return "clock"
            default: return nil
            }
        }
        
        var image: UIImage? {
            guard let imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        var textStyle: UIFont.TextStyle {
            switch self {
            case .title: return .headline
            default: return .subheadline
            }
        }
    }
}


/*
 Diffable data sources that supply UIKit lists with data and styling require that items conform to Hashable.
 The diffable data source uses hash values to determine which elements have changed between snapshots.
 */

/*
 Nonisolated breaks the automatic relation with MainActor (UIViewController).
 Sendable certifies that Row is secure to be transferred among actors and threads.
 */
