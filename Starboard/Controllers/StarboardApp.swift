//
//  StarboardApp.swift
//  Starboard
//
//  Created by David Barsamian on 11/13/20.
//

import SwiftUI
import FirstOpenViews
import CoreData

@main
struct StarboardApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .welcomeView(mainColor: .accentColor, informationDetailViews: [
                    InformationDetailView(title: "Make Goals", subTitle: "Create customized goals to focus on what's important.", image: Image(systemName: "list.star"), mainColor: .orange),
                    InformationDetailView(title: "Build Habits", subTitle: "Track your goals every day with a single tap.", image: Image(systemName: "star.circle.fill"), mainColor: Color("StarColor")),
                    InformationDetailView(title: "History", subTitle: "Keep track of your progress over time.", image: Image(systemName: "calendar"), mainColor: .red)
                ])
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
