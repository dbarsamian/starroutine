//
//  GoalsView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import CoreData
import Introspect
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
            if selectedGoal != nil {
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
                .sheet(isPresented: $showingAddGoals, onDismiss: {
                    if selectedGoal == nil, let firstGoal = goals.first {
                        selectedGoal = firstGoal.id
                    }
                }, content: {
                    AddGoalView()
                })
                .navigationBarTitle(Text("Goals"))

                Text("Nothing Selected")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            } else {
                Text("No Goals")
                    .toolbar {
                        ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                            Button(action: {
                                self.showingAddGoals.toggle()
                            }, label: {
                                Image(systemName: "plus.circle").imageScale(.large)
                            })
                        }
                    }
                    .sheet(isPresented: $showingAddGoals, onDismiss: {
                        if selectedGoal == nil, let firstGoal = goals.first {
                            selectedGoal = firstGoal.id
                        }
                    }, content: {
                        AddGoalView()
                    })
                Text("Nothing Selected")
            }
        }
        .onAppear {
            selectedGoal = goals.first?.id
        }
    }

    private func removeGoal(at offsets: IndexSet) {
        // Delete Object
        viewContext.perform {
            offsets.forEach { index in
                viewContext.delete(goals[index])
            }
        }
        try? viewContext.save()
        viewContext.refreshAllObjects()

        // Change detail view
        let currentGoal = goals.first { $0.id == selectedGoal }
        if let currentGoal = currentGoal, let currentIndex = goals.firstIndex(of: currentGoal) {
            if currentIndex > goals.startIndex {
                let previousIndex = goals.index(before: currentIndex)
                selectedGoal = goals[previousIndex].id
            } else {
                selectedGoal = nil
            }
        }
    }
}
