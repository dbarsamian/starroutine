//
//  AddGoalView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct AddGoalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel = AddGoalViewModel()

    @State private var showingStartDateCal = false
    @State private var showingEndDateCal = false

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    private static let calendar = Locale.current.calendar
    private static let icons: [String] = [
        "star.fill",
        "moon.stars.fill",
        "sparkles",
        "leaf.fill",
        "bookmark.circle.fill",
        "gift.circle.fill",
        "airplane.circle.fill"
    ]
    private static let hardModeDescription: String =
        """
        Hard Mode disables marking stars on past days, only letting you mark them on the day of the star. \
        Be careful, this cannot be changed after you make your goal!
        """

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Info")) {
                    TextField("Name",
                              text: $viewModel.name)
                        .keyboardType(.default)
                        .autocapitalization(.words)
                    TextField("Description",
                              text: $viewModel.desc)
                        .keyboardType(.default)
                    ColorPicker("Color",
                                selection: $viewModel.color)
                    HStack {
                        Text("Icon")
                        Spacer()
                        Picker(selection: $viewModel.icon,
                               label: Image(systemName: viewModel.icon)
                                   .foregroundColor(viewModel.color),
                               content: {
                                   ForEach(AddGoalView.icons,
                                           id: \.self) { icon in
                                       Image(systemName: icon)
                                   }
                               })
                            .accentColor(viewModel.color)
                            .pickerStyle(MenuPickerStyle())
                    }
                }
                Section(header: Text("Dates")) {
                    HStack {
                        Label("Start", systemImage: "hourglass.bottomhalf.fill")
                        Spacer()
                        Button(Self.dateFormatter.string(from: viewModel.startDate)) {
                            withAnimation {
                                showingStartDateCal.toggle()
                                showingEndDateCal = false
                            }
                        }
                    }
                    if showingStartDateCal {
                        DatePicker(selection: $viewModel.startDate, in: Date()..., displayedComponents: .date) {
                            Label("Start", systemImage: "hourglass.bottomhalf.fill")
                        }
                        .datePickerStyle(GraphicalDatePickerStyle())
                    }
                    HStack {
                        Label("End", systemImage: "hourglass.tophalf.fill")
                        Spacer()
                        Button(Self.dateFormatter.string(from: viewModel.endDate)) {
                            withAnimation {
                                showingEndDateCal.toggle()
                                showingStartDateCal = false
                            }
                        }
                    }
                    if showingEndDateCal {
                        DatePicker(selection: $viewModel.endDate, in: Self.calendar.date(
                            byAdding: .day,
                            value: 1,
                            to: viewModel.startDate
                        )! ... Self.calendar.date(
                            byAdding: .year,
                            value: 1,
                            to: viewModel.startDate
                        )!, displayedComponents: .date) {
                            Label("Start", systemImage: "hourglass.bottomhalf.fill")
                        }
                        .datePickerStyle(GraphicalDatePickerStyle())
                    }
                }
                Section(header: Text("Other"),
                        footer: Text("\(AddGoalView.hardModeDescription)")) {
                    Toggle(isOn: $viewModel.hardMode,
                           label: {
                               Text("Hard Mode")
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
                    createGoal()
                    // Save new goal
                    try? viewContext.save()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Add")
                }).disabled(viewModel.name.isEmpty || viewModel.desc.isEmpty)
            )
        }
    }

    private func createGoal() {
        // Create new goal
        let newGoal = Goal(context: viewContext)
        newGoal.name = viewModel.name
        newGoal.desc = viewModel.desc
        newGoal.startDate = viewModel.startDate
        newGoal.endDate = viewModel.endDate
        newGoal.color = UIColor(viewModel.color)
        newGoal.icon = viewModel.icon
        // Populate new goal's daysCompleted with however many Days
        var days: [Day] = []
        for dayNum in 1 ... newGoal.endDate!.interval(ofComponent: .day, fromDate: newGoal.startDate!) {
            let newDay = Day(context: viewContext)
            newDay.number = Int16(dayNum)
            newDay.date = Calendar.current.startOfDay(
                for: Calendar.current.date(
                    byAdding: .day,
                    value: dayNum - 1,
                    to: newGoal.startDate!
                )!
            )
            days.append(newDay)
        }
        newGoal.days = NSSet(array: days)
    }
}

struct AddGoalView_Preview: PreviewProvider {
    static var previews: some View {
        AddGoalView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
