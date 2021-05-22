//
//  StarboardView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct StarboardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var dayArray: [Day]?

    @ObservedObject var goal: Goal
    var dateFormatter: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateStyle = .medium
        return dformat
    }

    var body: some View {
        ScrollViewReader { proxy in
            List {
                if dayArray != nil {
                    ForEach(dayArray!, id: \Day.number) { day in
                        DayView(day: day)
                            .listRowBackground(
                                Calendar.current.startOfDay(
                                    for: Date()).compare(day.date!) == ComparisonResult.orderedSame ? (
                                    colorScheme == .dark ? Color(goal.color!).darken() :
                                        Color(goal.color!).lighten()
                                ) : Color(UIColor.secondarySystemGroupedBackground)
                            )
                    }
                    .frame(height: 75)
                }
            }
            .navigationBarTitle(Text(goal.name ?? ""))
            .listStyle(InsetGroupedListStyle())
            .onAppear {
                populateView()
                // Scroll to today
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

    func populateView() {
        dayArray = goal.days!.sortedArray(using: [NSSortDescriptor(keyPath: \Day.number, ascending: true)]) as? [Day]
    }
}
