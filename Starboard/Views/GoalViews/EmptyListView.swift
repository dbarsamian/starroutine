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
            Text("\"You are never too old to set a new goal\nor to dream a new dream.\" - C.S. Lewis")
                .padding(.horizontal, 25)
                .font(Font.subheadline.italic())
                .foregroundColor(Color(UIColor.secondaryLabel))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.showingAddGoals.toggle()
                    }, label: {
                        Image(systemName: "plus.circle").imageScale(.large)
                    })
                )
                .sheet(isPresented: $showingAddGoals, content: {
                    AddGoalView()
                })
                .navigationBarTitle("Goals")
            Spacer()
        }
    }
}
