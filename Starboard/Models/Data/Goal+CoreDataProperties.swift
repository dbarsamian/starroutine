//
//  Goal+CoreDataProperties.swift
//  Starboard
//
//  Created by David Barsamian on 1/15/21.
//
//

import Foundation
import CoreData
import UIKit

extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var color: UIColor?
    @NSManaged public var completed: Bool
    @NSManaged public var desc: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var daysCompleted: Int16
    @NSManaged public var days: NSSet?

}

// MARK: Generated accessors for days
extension Goal {

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: Day)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: Day)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSSet)

}

extension Goal : Identifiable {

}
