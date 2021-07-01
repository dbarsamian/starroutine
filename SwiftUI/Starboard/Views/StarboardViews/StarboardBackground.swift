//
//  StarboardBackground.swift
//  Starboard
//
//  Created by David Barsamian on 6/22/21.
//

import SwiftUI

struct StarboardBackground: View {
    @Environment(\.colorScheme) var colorScheme

    private var backgroundGradient: LinearGradient {
        if colorScheme == .light {
            return LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor").lighten(), Color("BackgroundColor")]), startPoint: .bottom, endPoint: .top)
        } else {
            return LinearGradient(gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").darken(by: 75)]), startPoint: .bottom, endPoint: .top)
        }
    }

    var body: some View {
        ParticlesEmitter {
            EmitterCell()
                .content(.circle(16.0))
                .color(.white.withAlphaComponent(0.0))
                .lifetime(20)
                .birthRate(80)
                .scale(0.01)
                .scaleRange(0.004)
                .scaleSpeed(0.005)
                .alphaSpeed(0.3)
                .velocity(120)
                .emissionRange(-.pi)
        }
        .emitterSize(CGSize(width: 1, height: 1))
        .emitterShape(.rectangle)
        .emitterPosition(CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2))
        .background(backgroundGradient)
        .edgesIgnoringSafeArea(.all)
    }
}

struct StarboardBackground_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StarboardBackground()
                .previewLayout(.fixed(width: 500, height: 500))
                .previewDisplayName("Light")
                .preferredColorScheme(.light)
            StarboardBackground()
                .previewLayout(.fixed(width: 500, height: 500))
                .previewDisplayName("Dark")
                .preferredColorScheme(.dark)
        }
    }
}
