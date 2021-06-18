//
//  AddGoalViewController.swift
//  Starboard
//
//  Created by David Barsamian on 6/17/21.
//

import Carbon
import UIKit

class AddGoalViewController: UITableViewController {
    /*
     What the form needs:
     - Name text field
     - Description text field
     - Color picker
     - Icon picker
     - Start date picker
     - End date picker
     - Hard mode toggle
     */
    enum ID {
        case name
        case description
        case colorPicker
        case iconPicker
        case startDatePicker
        case endDatePicker
        case hardModeToggle
    }
    
    struct State {
        var name: String?
        var desc: String?
        var color: UIColor? = .blue
        var iconName: Icon? = .star
        var startDate: Date?
        var endDate: Date?
        var hardMode: Bool? = false
        var isOpenIconPicker = false
    }
    
    var state = State() {
        didSet { render() }
    }
    
    private let renderer = Renderer(adapter: UITableViewAdapter(), updater: UITableViewUpdater())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Goal"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        renderer.target = tableView
        renderer.updater.deleteRowsAnimation = .middle
        renderer.updater.insertRowsAnimation = .middle
        
        render()
    }
    
    func render() {
        renderer.render {
            Group {
                Section(id: 1) {
                    Header("Info")
                        .identified(by: \.title)
                
                    STextField(title: "Name", text: state.name, placeholder: "Get Sleep") { [weak self] text in
                        self?.state.name = text
                    }
                    .identified(by: ID.name)
                
                    STextField(title: "Description", text: state.desc, placeholder: "Get eight hours of sleep every night.") { [weak self] text in
                        self?.state.desc = text
                    }
                    .identified(by: ID.description)
                
                    SColorPicker(title: "Color", color: state.color) { [weak self] color in
                        self?.state.color = color
                    }
                    .identified(by: ID.colorPicker)
                
                    SIconLabel(title: "Icon", image: UIImage(systemName: state.iconName!.rawValue), color: state.color) { [weak self] in
                        self?.state.isOpenIconPicker.toggle()
                    }
                    
                    if state.isOpenIconPicker {
                        SIconPicker(icons: Icon.allCases, color: state.color) { [weak self] iconName in
                            self?.state.iconName = Icon(rawValue: iconName)
                        }
                        .identified(by: ID.iconPicker)
                    }
                }
                Section(id: 2) {
                    Header("Dates")
                        .identified(by: \.title)
                    
                    SLabel(title: "Start Date", text: "Jan 01, 1969") {}
                    
                    SLabel(title: "End Date", text: "Jan 02, 1969") {}
                }
                // Advanced
                // Hard Mode Toggle
                Section(id: 3) {
                    Header("Advanced")
                        .identified(by: \.title)
                    
                    SLabel(title: "Hard Mode", text: "REPLACE ME") {}
                }
            }
        }
    }
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        tableView.contentInset.bottom = view.bounds.height - keyboardFrame.minY
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {}
}
