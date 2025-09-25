//
//  UIContentConfiguration+Stateless.swift
//  Today
//
//  Created by Uri on 25/9/25.
//

import UIKit

extension UIContentConfiguration {
    
    /// Allows a UIContentConfiguration to provide a specialized configuration for a given state
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
