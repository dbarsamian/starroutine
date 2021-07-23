//
//  GoalLinkView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct GoalLinkView: View {
    @ObservedObject var goal: Goal

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
                Text("\(goal.desc ?? "")")
                    .font(.subheadline)
                ProgressView(value: progress) {
                    Text("\(daysLeftDescription)")
                        .font(.caption)
                }
                .progressViewStyle(LinearProgressViewStyle(tint: Color(goal.color ?? .systemBlue)))
            }
            .onAppear(perform: populateView)
        }
    }

    func populateView() {
        guard goal.days != nil else { return }

        // Calculate progress
        withAnimation(.default) {
            progress = Float(goal.daysCompleted) / Float(goal.endDate!.interval(
                ofComponent: .day,
                fromDate: goal.startDate!
            ))
        }

        // Calculate days left description
        if goal.completed {
            daysLeftDescription = "(Goal completed!)"
        } else if goal.endDate!.interval(ofComponent: .day, fromDate: goal.startDate!) > 1 {
            let daysLeft = goal.endDate!.interval(ofComponent: .day, fromDate: goal.startDate!)
            daysLeftDescription = "\(daysLeft) days left."
        } else {
            daysLeftDescription = "1 day left!"
        }

        // Lock goal if end date is today
        let today = Calendar.current.startOfDay(for: Date())
        let end = Calendar.current.startOfDay(for: goal.endDate!)
        if Calendar.current.dateComponents([.day], from: today, to: end).day! == 0 {
            goal.completed = true
        }
    }
}
