//
//  DayListView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct DayListView: View {
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
            Text("Day \(self.day.number)")
                .font(.largeTitle)
            Spacer()
            Image(systemName: day.goal!.icon ?? "star")
                .font(.largeTitle)
                .scaleEffect(day.completed ? 1.5 : 0.75)
                .foregroundColor(day.completed ? Color(day.goal!.color as! UIColor) : Color.gray)
                .onTapGesture {
                    if !day.goal!.completed {
                        withAnimation(.interpolatingSpring(stiffness: 50, damping: 5)) {
                            self.day.completed.toggle()
                            dayComplete = self.day.completed
                        }
                    }
                }
                .animation(.spring())
        })
        .onReceive(self.day.objectWillChange) {
            try? self.viewContext.save()
        }
    }
}
