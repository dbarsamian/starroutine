//
//  Goal+CoreDataProperties.swift
//  Starboard
//
//  Created by David Barsamian on 6/17/21.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var identifier: UUID?
    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var iconName: String?
    @NSManaged public var colorRed: Float
    @NSManaged public var colorGreen: Float
    @NSManaged public var colorBlue: Float
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
