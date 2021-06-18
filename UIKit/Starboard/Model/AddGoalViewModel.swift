//
//  AddGoalViewModel.swift
//  Starboard
//
//  Created by David Barsamian on 6/17/21.
//

import Foundation
import UIKit

struct AddGoalViewModel {
    var identifier: UUID = UUID()
    var name: String = ""
    var desc: String = ""
    var startDate: Date = Date() {
        didSet {
            startDate = Locale.current.calendar.startOfDay(for: oldValue)
        }
    }
    var endDate: Date = Date() {
        didSet {
            // Must be at least one day after start date
            if oldValue > startDate {
                endDate = Locale.current.calendar.startOfDay(for: oldValue)
            } else {
                endDate = Locale.current.calendar.date(byAdding: .day, value: 1, to: startDate)!
            }
        }
    }
    var color: UIColor = .blue
    var iconName: String = "star.fill"
}
