//
//  Persistence.swift
//  Starboard
//
//  Created by David Barsamian on 11/13/20.
//

import CoreData
import UIKit

class PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()

    // Storage for Core Data
    let container: NSPersistentContainer

    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        // Create 10 example goals
        for goalNum in 0 ..< 10 {
            let goal = Goal(context: controller.container.viewContext)
            goal.name = "Test Goal \(goalNum)"
            goal.desc = "Lorem Ipsum"
            goal.startDate = Calendar.current.startOfDay(for: Date())
            goal.endDate = Calendar.current.date(byAdding: .day, value: 7, to: goal.startDate!)
            goal.color = UIColor.systemRed
            goal.icon = "cube"
            goal.hardMode = false

            var days: [Day] = []
            for dayNum in 1 ... goal.endDate!.interval(ofComponent: .day, fromDate: goal.startDate!) {
                let newDay = Day(context: controller.container.viewContext)
                newDay.number = Int16(dayNum)
                newDay.date = Calendar.current.startOfDay(
                    for: Calendar.current.date(
                        byAdding: .day,
                        value: dayNum - 1,
                        to: goal.startDate!
                    )!
                )
                days.append(newDay)
            }
            goal.days = NSSet(array: days)
        }

        return controller
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Starboard")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        let center = NotificationCenter.default
        let notification = UIApplication.willResignActiveNotification
        center.addObserver(forName: notification, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }

            if self.container.viewContext.hasChanges {
                try? self.container.viewContext.save()
            }
        }
    }

    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
