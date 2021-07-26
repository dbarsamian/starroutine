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
            return LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundColor").lighten(), Color("BackgroundColor")]),
                startPoint: .bottom,
                endPoint: .top
            )
        } else {
            return LinearGradient(
                gradient: Gradient(colors: [Color("BackgroundColor"), Color("BackgroundColor").darken(by: 50)]),
                startPoint: .bottom,
                endPoint: .top
            )
        }
    }

    var body: some View {
        GeometryReader { geo in
            ParticlesEmitter {
                EmitterCell()
                    .content(.circle(16))
                    .color(.white)
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
            .emitterPosition(CGPoint(x: geo.size.width / 2, y: geo.size.height / 2))
            .background(backgroundGradient)
            .edgesIgnoringSafeArea(.all)
            .mask(
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

struct StarboardBackground_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 0) {
            StarboardBackground()
                .environment(\.colorScheme, .light)
            StarboardBackground()
                .environment(\.colorScheme, .dark)
        }
    }
}
