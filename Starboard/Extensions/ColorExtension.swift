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
}
