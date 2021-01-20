//
//  ColorExtension.swift
//  Starboard
//
//  Created by David Barsamian on 12/27/20.
//

import Foundation
import SwiftUI

extension Color {
    func random() -> Color {
        return Color(red: Double.random(in: 0...255), green: Double.random(in: 0...255), blue: Double.random(in: 0...255))
    }
    
    func lighten(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: abs(percentage))
    }
    
    func darken(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    private func adjust(by percentage: CGFloat = 30.0) -> Color {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return Color(UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha))
        } else {
            return self
        }
    }
}
