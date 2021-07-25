//
//  StarboardView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//
// swiftlint:disable opening_brace
// swiftlint:disable line_length

import Introspect
import SwiftUI
import SwiftUIX

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
                        DayView(day: day)
                            .listRowBackground(VisualEffectBlurView(blurStyle: .regular, content: {
                                ZStack {
                                    RadialGradient(gradient: Gradient(colors: [rowColor(for: day.date!).opacity(0.5),
                                                                               rowColor(for: day.date!).opacity(0.25)]),
                                    center: .trailing,
                                    startRadius: 50,
                                    endRadius: 300)
                                        .saturation(1.5)
                                }
                            }))
                    }
                }
                .frame(height: 75)
            }
            .background(background)
            .navigationBarTitle(Text(goal.name ?? ""))
            .listStyle(InsetGroupedListStyle())
            .introspectTableView(customize: { tableView in
                tableView.backgroundColor = .clear
            })
            .onAppear { setup(with: proxy) }
            .onDisappear {
                UITableViewCell.appearance().backgroundColor = .systemBackground
            }
        }
    }
    
    @ViewBuilder
    var background: some View {
        ZStack {
            StarboardBackground()
            LinearGradient(gradient: Gradient(colors: [Color.systemBackground.opacity(0.75), Color.systemBackground.opacity(0)]), startPoint: .top, endPoint: UnitPoint(x: 0.5, y: 0.20))
                .edgesIgnoringSafeArea(.all)
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
            return .clear
        }
    }
    
    private func setup(with proxy: ScrollViewProxy) {
        UITableViewCell.appearance().backgroundColor = .clear
        
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
