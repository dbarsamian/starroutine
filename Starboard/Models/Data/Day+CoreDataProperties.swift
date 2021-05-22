//
//  Day+CoreDataProperties.swift
//  Starboard
//
//  Created by David Barsamian on 1/15/21.
//
//

import CoreData
import Foundation

public extension Day {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged var completed: Bool
    @NSManaged var date: Date?
    @NSManaged var number: Int16
    @NSManaged var goal: Goal?
}

extension Day: Identifiable {}
