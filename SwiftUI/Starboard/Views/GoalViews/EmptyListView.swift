//
//  EmptyListView.swift
//  Starboard
//
//  Created by David Barsamian on 11/22/20.
//

import SwiftUI

struct EmptyListView: View {
    @State var showingAddGoals = false

    var body: some View {
        VStack {
            Spacer()
            Text("No Goals")
                .font(.largeTitle)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                        Button(action: {
                            self.showingAddGoals.toggle()
                        }, label: {
                            Image(systemName: "plus.circle").imageScale(.large)
                        })
                    }
                }
                .sheet(isPresented: $showingAddGoals, content: {
                    AddGoalView()
                })
                .navigationBarTitle("Goals")
            Spacer()
        }
    }
}
