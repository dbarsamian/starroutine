//
//  GoalLinkView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct GoalLinkView: View {
    var goal: Goal

    var body: some View {
        HStack {
            Image(systemName: "star.circle.fill")
                .renderingMode(.original)
                .font(.title)
            VStack(alignment: .leading) {
                Text("\(goal.name ?? "")")
                    .font(.headline)
                Text("\(goal.desc!) (\(goal.completed ? "Goal completed!" : (goal.endDate!.interval(ofComponent: .day, fromDate: goal.startDate!) > 1 ? "\(goal.endDate!.interval(ofComponent: .day, fromDate: goal.startDate!)) days left." : "1 day left!")))")
                    .font(.subheadline)
            }
            .onAppear(perform: {
                if Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: goal.endDate!)).day! == 0 {
                    goal.completed = true
                }
            })
        }
    }
}
