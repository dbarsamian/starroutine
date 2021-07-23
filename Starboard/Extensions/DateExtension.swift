//
//  Date.swift
//  Starboard
//
//  Created by David Barsamian on 11/19/20.
//

import Foundation

extension Date {
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        guard let start = Calendar.current.ordinality(of: comp, in: .era, for: date) else {return 0}
        guard let end = Calendar.current.ordinality(of: comp, in: .era, for: self) else {return 0}
        return end - start
    }
}
