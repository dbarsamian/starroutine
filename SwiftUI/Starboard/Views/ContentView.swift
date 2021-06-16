//
//  ContentView.swift
//  Starboard
//
//  Created by David Barsamian on 11/13/20.
//

import CoreData
import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

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
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .previewDisplayName("Main")
        }
    }
}
