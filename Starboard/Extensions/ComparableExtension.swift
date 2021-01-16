//
//  ComparableExtension.swift
//  Starboard
//
//  Created by David Barsamian on 1/15/21.
//
//  https://stackoverflow.com/questions/36110620/standard-way-to-clamp-a-number-between-two-values-in-swift

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
