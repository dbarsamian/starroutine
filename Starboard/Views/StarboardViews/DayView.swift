//
//  DayListView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

// swiftlint:disable opening_brace
struct DayView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var day: Day
    @State private var dayComplete = false

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(day: Day) {
        self.day = day
        self.dayComplete = self.day.completed
    }

    var body: some View {
        if day.date != nil {
        HStack(alignment: .center, spacing: nil, content: {
            Spacer()
            VStack {
                if day.date!.timeIntervalSince(Calendar.current.startOfDay(for: Date())) <= 0 {
                    Text("Day \(self.day.number)")
                        .font(.largeTitle)
                } else {
                    Text("Day \(self.day.number)")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                if Calendar.current.startOfDay(for: Date()).compare(day.date!) == ComparisonResult.orderedSame {
                    Text("\(DayView.dateFormatter.string(from: day.date!)) - Today")
                        .font(.caption)
                        .italic()
                } else {
                    Text("\(DayView.dateFormatter.string(from: day.date!))")
                        .font(.caption)
                        .italic()
                }
            }
            Spacer()
            withAnimation(.interpolatingSpring(stiffness: 50, damping: 5)) {
                Image(systemName: day.goal?.icon ?? "star")
                    .font(.largeTitle)
                    .scaleEffect(day.date!.timeIntervalSince(
                        Calendar.current.startOfDay(for: Date())) <= 0 ? (
                        day.completed ? 1.5 : 1.0) :
                        0.75
                    )
                    .foregroundColor(day.completed ? Color(day.goal!.color!) : Color.gray)
                    .onTapGesture(perform: toggleStar)
            }
            .animation(.spring())
        })
            .onReceive(self.day.objectWillChange) {
                try? self.viewContext.save()
            }
        } else {
            EmptyView().onAppear {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func toggleStar() {
        // If this date is in the future OR
        // if hard mode is on and the date is in the past OR
        // if the goal has completed, don't allow marking
        let today = Calendar.current.startOfDay(for: Date())
        if self.day.date!.compare(today) == ComparisonResult.orderedDescending ||
            (self.day.goal!.hardMode &&
                self.day.date!.compare(today) == ComparisonResult.orderedAscending) ||
            self.day.goal!.completed
        {
            return
        }
        // else, mark/unmark the day
        self.day.completed.toggle()
        self.dayComplete = self.day.completed
        if self.dayComplete {
            self.day.goal!.daysCompleted = (self.day.goal!.daysCompleted + 1).clamped(
                to: 0...Int16(self.day.goal!.days!.count)
            )
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        } else {
            self.day.goal!.daysCompleted = (self.day.goal!.daysCompleted - 1).clamped(
                to: 0...Int16(self.day.goal!.days!.count)
            )
            let impact = UIImpactFeedbackGenerator(style: .soft)
            impact.impactOccurred()
        }
    }
}
