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
    
    // State variables
    @State private var showingStartDate = false
    @State private var showingEndDate = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Info")) {
                    TextField("Name", text: $name)
                        .keyboardType(.default)
                    TextField("Description", text: $desc)
                        .keyboardType(.default)
                }
                Section(header: Text("Dates")) {
                    DatePicker(selection: $startDate, in: Date()..., displayedComponents: .date, label: {
                        Text("Start Date")
                    })
                    DatePicker(selection: $endDate, in: Calendar.current.date(byAdding: .day, value: 1, to: self.startDate)! ... Calendar.current.date(byAdding: .year, value: 1, to: self.startDate)!, displayedComponents: .date, label: {
                        Text("End Date")
                    })
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
