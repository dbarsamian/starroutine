//
//  StarboardApp.swift
//  Starboard
//
//  Created by David Barsamian on 11/13/20.
//

import CoreData
import FirstOpenViews
import SwiftUI

@main
struct StarRoutineApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            GoalsView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .welcomeView(mainColor: .accentColor, informationDetailViews: [
                    InformationDetailView(
                        title: "Make Goals",
                        subTitle: "Create customized goals to focus on what's important.",
                        image: Image(systemName: "list.star"),
                        mainColor: .orange
                    ),
                    InformationDetailView(
                        title: "Build Habits",
                        subTitle: "Track your goals every day with a single tap.",
                        image: Image(systemName: "star.circle.fill"),
                        mainColor: Color("StarColor")
                    ),
                    InformationDetailView(
                        title: "History",
                        subTitle: "Keep track of your progress over time.",
                        image: Image(systemName: "calendar"),
                        mainColor: .red
                    )
                ])
        }
        .onChange(of: scenePhase) { _ in
            let viewContext = PersistenceController.shared.container.viewContext
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error: \(nsError.localizedDescription), \(nsError.userInfo)")
            }
        }
    }
}
