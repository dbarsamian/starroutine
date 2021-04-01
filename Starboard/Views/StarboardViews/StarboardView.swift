//
//  StarboardView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct StarboardView: View {
    @Environment(\.colorScheme) var colorScheme

    var goal: Goal
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }

    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(goal.days!.sortedArray(using: [NSSortDescriptor(keyPath: \Day.number, ascending: true)]) as! [Day], id: \Day.number) { day in
                    DayView(day: day)
                        .id(day.date)
                        .listRowBackground(Calendar.current.startOfDay(for: Date()).compare(day.date!) == ComparisonResult.orderedSame ? (colorScheme == .dark ? Color(goal.color!).darken() : Color(goal.color!).lighten()) : Color(UIColor.secondarySystemGroupedBackground))
                }
                .frame(height: 75)
            }
            .navigationBarTitle("Starboard")
            .listStyle(InsetGroupedListStyle())
            .onAppear { // Scroll to today
                for rawDate in goal.days! {
                    guard let date = rawDate as? Day else {
                        return
                    }
                    if Calendar.current.startOfDay(for: Date()).compare(date.date!) == ComparisonResult.orderedSame {
                        withAnimation(.default) {
                            proxy.scrollTo(Calendar.current.startOfDay(for: date.date!))
                        }
                    }
                }
            }
        }
    }
}
