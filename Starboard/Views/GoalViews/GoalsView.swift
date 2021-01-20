//
//  GoalsView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct GoalsView: View {
    // Environment
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentation
    @Environment(\.editMode) private var editMode

    // Core Data
    @FetchRequest(entity: Goal.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Goal.startDate, ascending: true), NSSortDescriptor(keyPath: \Goal.name, ascending: true)]) var goals: FetchedResults<Goal>

    // Properties
    @State var showingAddGoals = false
    @State var showingAlert = false
    @State private var selectedGoal: UUID?

    var body: some View {
        NavigationView {
            if goals.isEmpty {
                EmptyListView(showingAddGoals: showingAddGoals)
            } else {
                List {
                    ForEach(goals) { goal in
                        NavigationLink(
                            destination: StarboardView(goal: goal),
                            tag: goal.id!,
                            selection: $selectedGoal) {
                                GoalLinkView(goal: goal)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        deleteGoal(indexSet: indexSet, selectedGoal: $selectedGoal, goals: goals, showingAlert: $showingAlert)
                    })
                }
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                        EditButton()
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
                .navigationBarTitle("Goals")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private func deleteGoal(indexSet: IndexSet, selectedGoal: Binding<UUID?>, goals: FetchedResults<Goal>, showingAlert: Binding<Bool>) {
    selectedGoal.wrappedValue = nil
    let viewContext = PersistenceController.shared.container.viewContext
    for index in indexSet {
        viewContext.delete(goals[index])
    }
    do {
        try viewContext.save()
        print("Deletion done.")
    } catch {
        print("Error deleting goal: \(error.localizedDescription)")
        //        _ = alert(isPresented: showingAlert, content: {
        //            Alert(title: Text("⚠️ Error!"), message: Text("Could not save your changes. Please close and reopen the app to try again, or email david@davidbarsam.com"), dismissButton: .default(Text("OK")))
        //        })
    }
}
