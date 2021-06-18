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
    
    enum Icon: String, CaseIterable {
        case star = "star.fill"
        case moonAndStars = "moon.stars.fill"
        case moon = "moon.fill"
        case sun = "sun.max.fill"
        case tornado
        case drawing = "pencil.and.outline"
        case book = "book.fill"
        case bookmark = "bookmark.fill"
        case gradCap = "graduationcap.fill"
        case flag = "flag.fill"
        case camera = "camera.fill"
        case piano = "pianokeys.inverse"
        case paint = "paintbrush.fill"
        case puzzle = "puzzlepiece.fill"
        case map = "map.fill"
        case alarm = "alarm.fill"
        case walk = "figure.walk"
        case leaf = "leaf.fill"
        case creditCard = "creditcard.fill"
    }
    
    struct State {
        var name: String?
        var desc: String?
        var color: UIColor? = .blue
        var iconName: Icon? = .star
        var startDate: Date?
        var endDate: Date?
        var hardMode: Bool? = false
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
                
                    STextField(title: "Description", text: state.desc, placeholder: "Get eight hours of sleep every night.") { [weak self] text in
                        self?.state.desc = text
                    }
                
                    // Color Picker
                
                    // Icon Picker
                }
                // Dates
                    // Start Date Picker
                    // End Date Picker
                // Advanced
                    // Hard Mode Toggle
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
