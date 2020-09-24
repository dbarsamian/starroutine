//
//  Goal.swift
//  Starboard
//
//  Created by David Barsamian on 9/23/20.
//

import Foundation
import RealmSwift

class Goal : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var goalDescription : String = ""
    @objc dynamic var dateCreated : Date?
    let datesCompleted = List<Date>()
}
