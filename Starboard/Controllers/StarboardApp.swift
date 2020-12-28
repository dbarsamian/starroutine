//
//  StarboardApp.swift
//  Starboard
//
//  Created by David Barsamian on 11/13/20.
//

import SwiftUI
import CoreData
import os

@main
struct StarboardApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { (phase) in
            switch phase {
            case .background:
                saveContext()
            case .inactive:
                saveContext()
            default:
                break
            }
        }
    }
    
    func saveContext() {
        let context = persistenceController.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    
}
