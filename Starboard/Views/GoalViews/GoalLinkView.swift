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
            Image(systemName: goal.icon ?? "star.circle.fill")
                .font(.title)
                .foregroundColor(Color(goal.color as? UIColor ?? UIColor.yellow))
                .frame(maxWidth: 32.0)
            VStack(alignment: .leading) {
                Text("\(goal.name ?? "")")
                    .font(.headline)
                Text("\(goal.desc!)")
                    .font(.subheadline)
                Text("\(goal.completed ? "Goal completed!" : (goal.endDate!.interval(ofComponent: .day, fromDate: goal.startDate!) > 1 ? "\(goal.endDate!.interval(ofComponent: .day, fromDate: goal.startDate!)) days left." : "1 day left!"))")
                    .font(.caption)
            }
            .onAppear(perform: {
                if Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: goal.endDate!)).day! == 0 {
                    goal.completed = true
                }
            })
        }
    }
}
