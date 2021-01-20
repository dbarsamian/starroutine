//
//  AddGoalViewModel.swift
//  Starboard
//
//  Created by David Barsamian on 1/14/21.
//

import Foundation
import SwiftUI

class AddGoalViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var desc: String = ""
    @Published var startDate: Date = Calendar.current.startOfDay(for: Date()) {
        didSet {
            if endDate <= startDate {
                endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
            }
        }
    }
    @Published var endDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @Published var color = Color.blue
    @Published var icon: String = "star.fill"
    @Published var hardMode: Bool = false
}
