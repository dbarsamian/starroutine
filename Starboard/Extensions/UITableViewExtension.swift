//
//  UITableViewControllerExtension.swift
//  Starboard
//
//  Created by David Barsamian on 9/23/20.
//

import Foundation
import UIKit

extension UITableView {
    /// Reloads the rows and sections of the table view using a given animation effect.
    /// - Parameter with: A constant that indicates how the reloading is to be animated,  for example, fade out or slide out from the bottom. See UITableView.RowAnimation for descriptions of these constants.
    func reloadData(with animation: RowAnimation) {
        let range = NSMakeRange(0, self.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.reloadSections(sections as IndexSet, with: animation)
    }
}
