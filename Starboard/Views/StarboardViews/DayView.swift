//
//  DayListView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct DayView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var day: Day
    
    @State private var dayComplete = false
    
    init(day: Day) {
        self.day = day
        dayComplete = self.day.completed
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            Spacer()
            if day.date!.timeIntervalSince(Calendar.current.startOfDay(for: Date())) <= 0 {
                Text("Day \(self.day.number)")
                    .font(.largeTitle)
            } else {
                Text("Day \(self.day.number)")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: day.goal!.icon ?? "star")
                .font(.largeTitle)
                .scaleEffect(day.date!.timeIntervalSince(Calendar.current.startOfDay(for: Date())) <= 0 ? (day.completed ? 1.5 : 1.0) : 0.75)
                .foregroundColor(day.completed ? Color(day.goal!.color!) : Color.gray)
                .onTapGesture {
                    if !day.goal!.completed && day.date!.timeIntervalSince(Calendar.current.startOfDay(for: Date())) <= 0 {
                        withAnimation(.interpolatingSpring(stiffness: 50, damping: 5)) {
                            self.day.completed.toggle()
                            dayComplete = self.day.completed
                            if dayComplete {
                                self.day.goal!.daysCompleted = (self.day.goal!.daysCompleted + 1).clamped(to: 0...Int16(self.day.goal!.days!.count))
                                print("Day complete, total is now \(self.day.goal!.daysCompleted)")
                            } else {
                                self.day.goal!.daysCompleted = (self.day.goal!.daysCompleted - 1).clamped(to: 0...Int16(self.day.goal!.days!.count))
                                print("Day uncomplete, total is now \(self.day.goal!.daysCompleted)")
                            }
                        }
                    } else {
                        // shake animation
                    }
                }
                .animation(.spring())
        })
        .onReceive(self.day.objectWillChange) {
            try? self.viewContext.save()
        }
        .onAppear() {
            
        }
    }
}
