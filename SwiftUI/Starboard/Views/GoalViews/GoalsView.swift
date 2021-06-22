//
//  GoalsView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import CoreData
import SwiftUI

struct GoalsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentation
    @Environment(\.editMode) private var editMode

    @FetchRequest(fetchRequest: PersistenceController.goalFetchRequest) var goals

    @State var selectedGoal: ObjectIdentifier?
    @State var showingAddGoals = false

    var body: some View {
        NavigationView {
            List {
                ForEach(goals) { goal in
                    NavigationLink(
                        destination: StarboardView(goal: goal),
                        tag: goal.id,
                        selection: $selectedGoal
                    ) {
                        GoalLinkView(goal: goal)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        viewContext.delete(goals[index])
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error: \(nsError.localizedDescription), \(nsError.userInfo)")
                    }
                })
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    if goals.count > 0 {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        self.showingAddGoals.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .listStyle(InsetGroupedListStyle())
            .sheet(isPresented: $showingAddGoals, content: {
                AddGoalView()
            })
            .navigationBarTitle(Text("Goals"))
        }
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
