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
    @State var dayArray = [Day]()

    let backgroundHost = UIHostingController(rootView: StarboardBackground())

    @StateObject var goal: Goal
    var dateFormatter: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateStyle = .medium
        return dformat
    }

    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(dayArray, id: \Day.number) { day in
                    if day.date != nil {
                        DayView(day: day)
                            .listRowBackground(
                                Calendar.current.startOfDay(
                                    for: Date()).compare(day.date!) == ComparisonResult.orderedSame ? (
                                    colorScheme == .dark ? Color(goal.color!).darken() :
                                        Color(goal.color!).lighten()
                                ) : Color(UIColor.secondarySystemGroupedBackground)
                            )
                    }
                }
                .frame(height: 75)
            }
            .navigationBarTitle(Text(goal.name ?? ""))
            .listStyle(InsetGroupedListStyle())
            .onAppear {
                UITableView.appearance().backgroundView = backgroundHost.view

                // Populate day array and scroll to today
                let descriptor = NSSortDescriptor(keyPath: \Day.number, ascending: true)
                if let days = goal.days,
                   let array = days.sortedArray(using: [descriptor]) as? [Day]
                {
                    dayArray = array
                    let cal = Locale.current.calendar
                    for day in dayArray {
                        if let date = day.date, cal.startOfDay(for: Date()).compare(date) == .orderedSame {
                            withAnimation(.default) {
                                proxy.scrollTo(cal.startOfDay(for: date))
                            }
                        }
                    }
                }
            }
        }
    }
}
