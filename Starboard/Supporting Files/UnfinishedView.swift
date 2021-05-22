//
//  UnfinishedView.swift
//  Starboard
//
//  Created by David Barsamian on 12/28/20.
//

import SwiftUI

struct UnfinishedView: View {
    @State var title: String = ""

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64.0, height: 64.0)
            Spacer()
                .frame(height: 25.0)
            Text("\(title) is under construction!")
                .font(.largeTitle)
        }
    }
}

struct UnfinishedView_Previews: PreviewProvider {
    static var previews: some View {
        UnfinishedView()
    }
}
