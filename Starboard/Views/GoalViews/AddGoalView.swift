//
//  AddGoalView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct AddGoalView: View {
    @Environment(\.managedObjectContext) private var viewContext // For Core Data
    @Environment(\.presentationMode) var presentationMode // For modal view control
    
    // New goal data
    @ObservedObject var viewModel = AddGoalViewModel()
    
    // State variables
    @State private var showingStartDate = false
    @State private var showingEndDate = false
    
    // Formatting
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    // Constant
    static let icons: [String] = [
        "star.fill",
        "moon.stars.fill",
        "sparkles",
        "leaf.fill",
        "bookmark.circle.fill",
        "gift.circle.fill",
        "airplane.circle.fill"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Info")) {
                    TextField("Name", text: $viewModel.name)
                        .keyboardType(.default)
                    TextField("Description", text: $viewModel.desc)
                        .keyboardType(.default)
                    ColorPicker("Color", selection: $viewModel.color)
                    Picker(selection: $viewModel.icon, label: Text("Icon"), content: {
                        ForEach(AddGoalView.icons, id: \.self) { icon in
                            Image(systemName: icon)
                        }
                    })
                }
                Section(header: Text("Dates")) {
                    // Start Date
                    HStack {
                        Label("Start Date", systemImage: "calendar")
                        Spacer()
                        Text("\($viewModel.startDate.wrappedValue, formatter: AddGoalView.dateFormatter)")
                    }
                    .onTapGesture {
                        showingStartDate.toggle()
                        showingEndDate = false
                    }
                    if showingStartDate {
                        DatePicker(selection: $viewModel.startDate, in: Date()..., displayedComponents: .date) {}
                            .labelsHidden()
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                    // End Date
                    HStack {
                        Label("End Date", systemImage: "calendar")
                        Spacer()
                        Text("\($viewModel.endDate.wrappedValue, formatter: AddGoalView.dateFormatter)")
                    }
                    .onTapGesture {
                        showingStartDate = false
                        showingEndDate.toggle()
                    }
                    if showingEndDate {
                        DatePicker(selection: $viewModel.endDate, in: Calendar.current.date(byAdding: .day, value: 1, to: $viewModel.startDate.wrappedValue)! ... Calendar.current.date(byAdding: .year, value: 1, to: $viewModel.startDate.wrappedValue)!, displayedComponents: .date) {}
                            .labelsHidden()
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                }
            }
            .navigationBarTitle("New Goal", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                }),
                trailing: Button(action: {
                    // Create new goal
                    let newGoal = Goal(context: viewContext)
                    newGoal.name = $viewModel.name.wrappedValue
                    newGoal.desc = $viewModel.desc.wrappedValue
                    newGoal.startDate = $viewModel.startDate.wrappedValue
                    newGoal.endDate = $viewModel.endDate.wrappedValue
                    newGoal.color = UIColor($viewModel.color.wrappedValue)
                    newGoal.icon = $viewModel.icon.wrappedValue
                    newGoal.id = UUID()
                    // Populate new goal's daysCompleted with however many Days
                    var days: [Day] = []
                    for n in 1 ... newGoal.endDate!.interval(ofComponent: .day, fromDate: newGoal.startDate!) {
                        let newDay = Day(context: viewContext)
                        newDay.number = Int16(n)
                        newDay.date = Calendar.current.startOfDay(for: Date())
                        days.append(newDay)
                    }
                    newGoal.daysCompleted = NSSet(array: days)
                    
                    // Save new goal
                    try? viewContext.save()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Add")
                }).disabled($viewModel.name.wrappedValue.isEmpty || $viewModel.desc.wrappedValue.isEmpty)
            )
        }
    }
}
