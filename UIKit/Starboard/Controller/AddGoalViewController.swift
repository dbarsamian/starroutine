//
//  AddGoalViewController.swift
//  Starboard
//
//  Created by David Barsamian on 6/17/21.
//

import SnapKit
import UIKit

class AddGoalViewController: UITableViewController {
    // MARK: - Outlets
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descTextField: UITextField!
    @IBOutlet var colorWellParentView: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    @IBOutlet var hardModeSwitch: UISwitch!
    @IBOutlet var iconPickerCell: UITableViewCell!
    @IBOutlet var iconPickerView: UIPickerView!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet var datePickerView: UIDatePicker!
    @IBOutlet var iconLabelCell: UITableViewCell!
    @IBOutlet var startDateLabelCell: UITableViewCell!
    @IBOutlet var endDateLabelCell: UITableViewCell!
    
    // MARK: - Variables
    private let dataSource = AddGoalDataSource()
    private var viewModel = AddGoalViewModel()
    private var colorWell: UIColorWell!
    private var iconLabelCellIndexPath: IndexPath?
    private var startDateLabelCellIndexPath: IndexPath?
    private var endDateLabelCellIndexPath: IndexPath?
    
    static let iconPickerCellIdentifier = "IconPickerCell"
    static let datePickerCellIdentifier = "DatePickerCell"
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view
        tableView.delegate = self
        
        // Get index paths for cells that act as buttons
        iconLabelCellIndexPath = tableView.indexPath(for: iconLabelCell)
        startDateLabelCellIndexPath = tableView.indexPath(for: startDateLabelCell)
        endDateLabelCellIndexPath = tableView.indexPath(for: endDateLabelCell)
        
        
        
        // Register icon and date picker cells
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.iconPickerCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.datePickerCellIdentifier)
        
        // Set up color well
        colorWell = UIColorWell(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        colorWell.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
        colorWell.selectedColor = .systemBlue
        colorWellParentView.addSubview(colorWell)
        colorWell.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func colorChanged() {
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {}
}

// MARK: - TableView
extension AddGoalViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let iconLabelCellIndexPath = iconLabelCellIndexPath, indexPath == iconLabelCellIndexPath {
            showingIconPicker.toggle()
        }
        if let startDateLabelCellIndexPath = startDateLabelCellIndexPath, indexPath == startDateLabelCellIndexPath {
            showingStartDatePicker.toggle()
        }
        if let endDateLabelCellIndexPath = endDateLabelCellIndexPath, indexPath == endDateLabelCellIndexPath {
            showingEndDatePicker.toggle()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
