//
//  SDatePicker.swift
//  Starboard
//
//  Created by David Barsamian on 6/18/21.
//

import Carbon
import UIKit

struct SDatePicker: IdentifiableComponent {
    var title: String
    var date: Date?
    var onUpdate: (Date) -> Void
    
    var id: String {
        title
    }
    
    var reuseIdentifier: String {
        title
    }
    
    func renderContent() -> SDatePickerContent {
        .loadFromNib()
    }
    
    func render(in content: SDatePickerContent) {
        content.datePicker.date = date ?? Date()
        content.onUpdate = onUpdate
    }
    
    func shouldRender(next: SDatePicker, in content: SDatePickerContent) -> Bool {
        false
    }
}

final class SDatePickerContent: UIView, NibLoadable {
    @IBOutlet var datePicker: UIDatePicker!
    var onUpdate: ((Date) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Locale.current.calendar.startOfDay(for: Date())
        datePicker.maximumDate = Locale.current.calendar.date(byAdding: .year, value: 1, to: datePicker.minimumDate ?? Date())
        datePicker.setValue(UIColor.link, forKey: "textColor")
        datePicker.addTarget(self, action: #selector(update), for: .valueChanged)
    }
    
    @objc func update() {
        onUpdate?(datePicker.date)
    }
}
