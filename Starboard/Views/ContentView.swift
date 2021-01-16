//
//  ContentView.swift
//  Starboard
//
//  Created by David Barsamian on 11/13/20.
//

import CoreData
import os
import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    var body: some View {
        TabView {
            GoalsView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Starboard")
                }
            HistoryView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("History")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var goal: Goal {
        let g = Goal(context: PersistenceController.preview.container.viewContext)
        g.name = "Test"
        g.desc = "This is a test"
        g.startDate = Date()
        g.endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        g.id = UUID()
        var daysCompleted = [Day]()
        for n in 1 ... g.endDate!.interval(ofComponent: .day, fromDate: g.startDate!) {
            let day = Day(context: PersistenceController.preview.container.viewContext)
            day.completed = false
            day.number = Int16(n)
            daysCompleted.append(day)
        }
        g.days = NSSet(array: daysCompleted)
        return g
    }

    static var previews: some View {
        Group {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewDisplayName("Main")
            GoalsView()
                .previewDisplayName("GoalsView")
            AddGoalView()
                .previewDisplayName("AddGoal")
            StarboardView(goal: goal)
                .previewDisplayName("StarboardView")
            HistoryView()
                .previewDisplayName("HistoryView")
            SettingsView()
                .previewDisplayName("SettingsView")
        }
    }
}
