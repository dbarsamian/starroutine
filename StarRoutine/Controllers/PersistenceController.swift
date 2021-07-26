//
//  Persistence.swift
//  Starboard
//
//  Created by David Barsamian on 11/13/20.
//

import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let cal = Locale.current.calendar
        let today = cal.startOfDay(for: Date())
        for goalNum in 0 ..< 10 {
            let newGoal = Goal(context: viewContext)
            newGoal.color = UIColor.systemPink
            newGoal.completed = false
            newGoal.desc = "Test Goal \(goalNum)"
            newGoal.startDate = today
            newGoal.endDate = Locale.current.calendar.date(byAdding: .day, value: 7, to: today)
            newGoal.hardMode = false
            newGoal.icon = "questionmark.diamond.fill"
            newGoal.name = "Goal \(goalNum)"
            for dayNum in 1 ... newGoal.endDate!.interval(ofComponent: .day, fromDate: newGoal.startDate!) {
                let newDay = Day(context: viewContext)
                newDay.completed = false
                newDay.number = Int16(dayNum)
                let date = cal.date(byAdding: .day, value: dayNum - 1, to: newGoal.startDate!)
                newDay.date = cal.startOfDay(for: date!)
                newGoal.addToDays(newDay)
            }
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    static var goalFetchRequest: NSFetchRequest<Goal> = {
        var request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Goal.startDate, ascending: true),
            NSSortDescriptor(keyPath: \Goal.name, ascending: true)
        ]
        return request
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "StarRoutine")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
    }
}
