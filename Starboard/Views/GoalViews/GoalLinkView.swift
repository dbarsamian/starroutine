//
//  GoalLinkView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct GoalLinkView: View {
    var goal: Goal

    @State var progress: Float = 0
    @State var daysLeftDescription: String = ""

    var body: some View {
        HStack {
            // Icon
            Image(systemName: goal.icon ?? "star.circle.fill")
                .font(.title)
                .foregroundColor(Color(goal.color ?? UIColor.yellow))
                .frame(maxWidth: 32.0)
            // Name, Description, Time Left
            VStack(alignment: .leading) {
                Text("\(goal.name ?? "")")
                    .font(.headline)
                Text("\(goal.desc!)")
                    .font(.subheadline)
                ProgressView(value: $progress.wrappedValue) {
                    Text("\($daysLeftDescription.wrappedValue)")
                        .font(.caption)
                }
                .progressViewStyle(LinearProgressViewStyle(tint: Color(goal.color ?? .systemBlue)))
            }
            .onAppear(perform: {
                // Calculate progress
                withAnimation(.easeOut) {
                    $progress.wrappedValue = Float(goal.daysCompleted) / Float(goal.endDate!.interval(ofComponent: .day, fromDate: goal.startDate!))
                }

                // Calculate days left description
                daysLeftDescription = "(\(goal.completed ? "Goal completed!)" : (goal.endDate!.interval(ofComponent: .day, fromDate: goal.startDate!) > 1 ? "\(goal.endDate!.interval(ofComponent: .day, fromDate: goal.startDate!)) days left." : "1 day left!")))"

                // Lock goal if end date is today
                if Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: goal.endDate!)).day! == 0 {
                    goal.completed = true
                }
            })
        }
    }
}
