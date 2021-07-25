//
//  Goal+CoreDataProperties.swift
//  Starboard
//
//  Created by David Barsamian on 6/21/21.
//
//

import CoreData
import Foundation
import UIKit

public extension Goal {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged var color: UIColor?
    @NSManaged var completed: Bool
    @NSManaged var daysCompleted: Int16
    @NSManaged var desc: String?
    @NSManaged var endDate: Date?
    @NSManaged var hardMode: Bool
    @NSManaged var icon: String?
    @NSManaged var name: String?
    @NSManaged var startDate: Date?
    @NSManaged var days: NSSet?
}

// MARK: Generated accessors for days

public extension Goal {
    @objc(addDaysObject:)
    @NSManaged func addToDays(_ value: Day)

    @objc(removeDaysObject:)
    @NSManaged func removeFromDays(_ value: Day)

    @objc(addDays:)
    @NSManaged func addToDays(_ values: NSSet)

    @objc(removeDays:)
    @NSManaged func removeFromDays(_ values: NSSet)
}

extension Goal: Identifiable {}
