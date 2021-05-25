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

    @FetchRequest(
        entity: Goal.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Goal.startDate, ascending: true),
            NSSortDescriptor(keyPath: \Goal.name, ascending: true)
        ],
        animation: .default
    ) private var goals: FetchedResults<Goal>

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
                .onDelete(perform: removeGoal)
            }
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                    if goals.count > 0 {
                        EditButton()
                    }
                }
                ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                    Button(action: {
                        self.showingAddGoals.toggle()
                    }, label: {
                        Image(systemName: "plus.circle").imageScale(.large)
                    })
                }
            }
            .listStyle(InsetGroupedListStyle())
            .sheet(isPresented: $showingAddGoals, content: {
                AddGoalView()
            })
            .onChange(of: goals.count, perform: { _ in
                if let first = goals.first {
                    selectedGoal = first.id
                }
            })
            .navigationBarTitle(Text("Goals"))

            EmptyDetailView()
        }
    }

    private func removeGoal(at offsets: IndexSet) {
        for index in offsets {
            let goal = goals[index]
            viewContext.delete(goal)
        }
    }
}
