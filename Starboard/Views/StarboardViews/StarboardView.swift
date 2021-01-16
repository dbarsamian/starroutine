//
//  StarboardView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct StarboardView: View {
    var goal: Goal
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }
    
    var body: some View {
        List() {
            ForEach(goal.days!.sortedArray(using: [NSSortDescriptor(keyPath: \Day.number, ascending: true)]) as! [Day], id: \Day.number) { day in
                DayView(day: day)
                    .id(day.date)
            }
            .frame(height: 75)
        }
        .navigationBarTitle("Starboard")
        .listStyle(InsetGroupedListStyle())
    }
}
