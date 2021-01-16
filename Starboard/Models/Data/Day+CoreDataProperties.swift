//
//  Day+CoreDataProperties.swift
//  Starboard
//
//  Created by David Barsamian on 1/15/21.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var date: Date?
    @NSManaged public var number: Int16
    @NSManaged public var goal: Goal?

}

extension Day : Identifiable {

}
