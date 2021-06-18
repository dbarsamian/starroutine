//
//  AddGoalDataSource.swift
//  Starboard
//
//  Created by David Barsamian on 6/17/21.
//

import UIKit

class AddGoalDataSource: NSObject {
    @objc dynamic private var showingIconPicker = false
    @objc dynamic private var showingStartDatePicker = false
    @objc dynamic private var showingEndDatePicker = false
    private var iconPickerStatusObservation: NSKeyValueObservation?
    private var startDateStatusObservation: NSKeyValueObservation?
    private var endDateStatusObservation: NSKeyValueObservation?
    
    override init() {
        super.init()
        
        // Set up KVO for the picker cells
        iconPickerStatusObservation = observe(\.showingIconPicker, changeHandler: { _, value in
            if let isShowing = value.newValue, let indexPath = self.iconLabelCellIndexPath {
                if isShowing {
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                } else {
                    let nextIndex = IndexPath(index: indexPath.index(after: indexPath.startIndex))
                    self.tableView.deleteRows(at: [nextIndex], with: .automatic)
                }
            }
        })
    }
}

extension AddGoalDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
