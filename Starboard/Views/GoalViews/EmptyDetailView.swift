//
//  EmptyDetailView.swift
//  Starboard
//
//  Created by David Barsamian on 5/7/21.
//

import SwiftUI

struct EmptyDetailView: View {
    var body: some View {
        Text("No Goal Selected")
            .font(.largeTitle)
            .foregroundColor(Color(UIColor.secondaryLabel))
    }
}

struct EmptyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyDetailView()
    }
}
