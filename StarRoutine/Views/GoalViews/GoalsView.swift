//
//  GoalsView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import CoreData
import SwiftUI
import SwiftUIX

struct GoalsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentation
    @Environment(\.editMode) private var editMode

    @FetchRequest(fetchRequest: PersistenceController.goalFetchRequest) var goals

    private enum SortMode: String, CaseIterable {
        case none = "None"
        case name = "Name"
        case daysLeft = "Days Left"
    }

    @State private var sortMode: SortMode = .none
    @State private var selectedGoal: ObjectIdentifier?
    @State private var showingAddGoals = false
    @State private var searchText = ""

    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                listView
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    if goals.count > 0 {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        self.showingAddGoals.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItemGroup(placement: ToolbarItemPlacement.bottomBar) {
                    Menu {
                        ForEach(SortMode.allCases, id: \.self) { mode in
                            Button {
                                sortMode = mode
                            } label: {
                                Text("\(mode.rawValue)")
                            }
                        }
                    } label: {
                        Image(systemName: sortMode == .none
                            ? "line.3.horizontal.decrease.circle"
                            : "line.3.horizontal.decrease.circle.fill")
                    }
                    Spacer()
                    Text(sortMode == .none ? "" : "Sort by: \(sortMode.rawValue)")
                        .font(Font.caption)
                    Spacer()
                }
            }
            .listStyle(InsetGroupedListStyle())
            .sheet(isPresented: $showingAddGoals, content: {
                AddGoalView()
            })
            .navigationBarTitle(Text("Goals"))
            .onAppear {
                UITableViewCell.appearance().backgroundColor = .systemBackground
            }
            .navigationSearchBar {
                SearchBar("Search for a goal", text: $searchText)
            }
            .navigationSearchBarHiddenWhenScrolling(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - List View

    private var listView: some View {
        ForEach(sortMode == .none
            ? Array(goals)
            .filter { goal in
                searchText.isEmpty == true ? true : goal.name!.contains(searchText)
            }
            : goals
            .sorted { first, second in
                switch sortMode {
                case .name:
                    return first.name ?? "" < second.name ?? ""
                case .daysLeft:
                    return first.daysLeft < second.daysLeft
                case .none:
                    return true
                }
            }
            .filter { goal in
                searchText.isEmpty == true ? true : goal.name!.contains(searchText)
            }
        ) { goal in
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
}

struct GoalsView_Preview: PreviewProvider {
    static var previews: some View {
        GoalsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
