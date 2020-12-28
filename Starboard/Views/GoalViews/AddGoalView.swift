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
    @State var name: String = ""
    @State var desc: String = ""
    @State var startDate: Date = Calendar.current.startOfDay(for: Date())
    @State var endDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    @State var color = Color.blue
    @State var icon: String = "star.fill"
    
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
                    TextField("Name", text: $name)
                        .keyboardType(.default)
                    TextField("Description", text: $desc)
                        .keyboardType(.default)
                    ColorPicker("Color", selection: $color)
                    Picker(selection: $icon, label: Text("Icon"), content: {
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
                        Text("\(startDate, formatter: AddGoalView.dateFormatter)")
                    }
                    .onTapGesture {
                        showingStartDate.toggle()
                        showingEndDate = false
                    }
                    if showingStartDate {
                        DatePicker(selection: $startDate, in: Date()..., displayedComponents: .date) {}
                            .labelsHidden()
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                    // End Date
                    HStack {
                        Label("End Date", systemImage: "calendar")
                        Spacer()
                        Text("\(endDate, formatter: AddGoalView.dateFormatter)")
                    }
                    .onTapGesture {
                        showingStartDate = false
                        showingEndDate.toggle()
                    }
                    if showingEndDate {
                        DatePicker(selection: $endDate, in: Calendar.current.date(byAdding: .day, value: 1, to: self.startDate)! ... Calendar.current.date(byAdding: .year, value: 1, to: self.startDate)!, displayedComponents: .date) {}
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
                    newGoal.name = name
                    newGoal.desc = desc
                    newGoal.startDate = startDate
                    newGoal.endDate = endDate
                    newGoal.color = UIColor(color)
                    newGoal.icon = icon
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
                }).disabled(name.isEmpty || desc.isEmpty)
            )
        }
    }
}
