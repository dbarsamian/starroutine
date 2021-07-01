//
//  StarboardView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//
// swiftlint:disable opening_brace

import SwiftUI

struct StarboardView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var dayArray = [Day]()

    @StateObject var goal: Goal

    private var dateFormatter: DateFormatter {
        let dformat = DateFormatter()
        dformat.dateStyle = .medium
        return dformat
    }

    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(dayArray, id: \Day.number) { day in
                    if day.date != nil {
                        if #available(iOS 15.0, *) {
                            DayView(day: day)
                                .listRowSeparator(.hidden)
                                .listRowBackground(rowColor(for: day.date!).opacity(0.2).background(.ultraThinMaterial))
                        } else {
                            DayView(day: day)
                                .listRowBackground(rowColor(for: day.date!).opacity(0.2))
                        }
                    }
                }
                .frame(height: 75)
            }
            .background(StarboardBackground())
            .navigationBarTitle(Text(goal.name ?? ""))
            .listStyle(.insetGrouped)
            .onAppear { setup(with: proxy) }
        }
    }

    private func rowColor(for date: Date) -> Color {
        let today = Locale.current.calendar.startOfDay(for: Date())
        if today.compare(date) == .orderedSame {
            if colorScheme == .light {
                return Color(goal.color!).lighten()
            } else {
                return Color(goal.color!).darken()
            }
        } else {
            return Color(UIColor.secondarySystemGroupedBackground)
        }
    }

    private func setup(with proxy: ScrollViewProxy) {
        UITableView.appearance().backgroundColor = .clear

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
