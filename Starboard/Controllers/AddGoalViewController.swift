//
//  AddGoalViewController.swift
//  Starboard
//
//  Created by David Barsamian on 9/23/20.
//

import UIKit
import DatePickerCell

// MARK: - AddGoalDelegate Protocol

protocol AddGoalDelegate {
    func addGoal(goal: Goal)
}

// MARK: - Class

class AddGoalViewController: UITableViewController {
    
    // Section 1
    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var TitleFieldCell: UITableViewCell!
    @IBOutlet weak var DescriptionField: UITextField!
    @IBOutlet weak var DescriptionFieldCell: UITableViewCell!
    
    // Section 2
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DateLabelCell: UITableViewCell!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var DatePickerCell: UITableViewCell!
    var datePickerCellIsHidden = true
    
    var delegate: AddGoalDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        // Set up table view
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        
        // Set up date picker
        DatePicker.preferredDatePickerStyle = .inline
        DatePicker.minimumDate = Date()
        DatePickerCell.isHidden = true
        updateDateLabel(with: DatePicker.date)
        
        // Set up navigation items
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        self.navigationItem.title = "Add Goal"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) == DateLabelCell {
            tableView.beginUpdates()
            DatePickerCell.isHidden = !DatePickerCell.isHidden
            tableView.layoutIfNeeded()
            tableView.endUpdates()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Date Picker
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        updateDateLabel(with: sender.date)
    }
    
    func updateDateLabel(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        DateLabel.text = dateFormatter.string(from: date)
    }
    
    // MARK: - Button Handlers
    
    @objc func handleDone() {
        guard let titleText = TitleField.text, TitleField.hasText else {
            let alert = UIAlertController(title: "Title Required", message: "You must give your new goal a name.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        guard let descriptionText = DescriptionField.text, DescriptionField.hasText else {
            let alert = UIAlertController(title: "Description Required", message: "You must give your new goal a description.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        
        let goal = Goal()
        goal.title = titleText
        goal.goalDescription = descriptionText
        goal.dateCreated = Date()
        delegate?.addGoal(goal: goal)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }

}
