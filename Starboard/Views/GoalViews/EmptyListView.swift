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
        Text("There's no goals here!\nTap the plus icon to make a new one.")
            .padding(.all)
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
    }
}
