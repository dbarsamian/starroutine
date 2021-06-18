//
//  Day+CoreDataProperties.swift
//  Starboard
//
//  Created by David Barsamian on 6/17/21.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var identifier: UUID?
    @NSManaged public var number: Int16
    @NSManaged public var date: Date?
    @NSManaged public var complete: Bool
    @NSManaged public var goal: Goal?

}

extension Day : Identifiable {

}
