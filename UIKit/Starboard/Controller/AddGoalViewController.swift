//
//  AddGoalViewController.swift
//  Starboard
//
//  Created by David Barsamian on 6/17/21.
//

import Carbon
import UIKit

class AddGoalViewController: UITableViewController {
    // Carbon
    enum ID {
        case name
        case description
        case colorPicker
        case iconPicker
        case startDatePicker
        case endDatePicker
    }

    struct State {
        var name: String?
        var desc: String?
        var color: UIColor? = .blue
        var iconName: Icon? = .star
        var startDate: Date? {
            didSet {
                if let date = startDate {
                    startDate = Locale.current.calendar.startOfDay(for: date)
                }
            }
        }

        var endDate: Date? {
            didSet {
                if let date = endDate {
                    endDate = Locale.current.calendar.startOfDay(for: date)
                }
            }
        }

        var isOpenIconPicker = false
        var isOpenStartDatePicker = false
        var isOpenEndDatePicker = false
    }

    var state = State() {
        didSet { render() }
    }

    private let renderer = Renderer(adapter: UITableViewAdapter(), updater: UITableViewUpdater())
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }
    
    // Local
    @IBOutlet var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Goal"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        renderer.target = tableView
        renderer.updater.deleteRowsAnimation = .fade
        renderer.updater.insertRowsAnimation = .fade
        
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
                    
                    SLabel(title: "Start Date", text: dateFormatter.string(from: state.startDate ?? Date())) { [weak self] in
                        self?.state.isOpenStartDatePicker.toggle()
                    }
                    
                    if state.isOpenStartDatePicker {
                        SDatePicker(title: "Start Date", date: state.startDate) { [self] startDate in
                            self.state.startDate = startDate
                            if let endDate = self.state.endDate, endDate < startDate {
                                self.state.endDate = startDate
                            }
                            self.state.isOpenStartDatePicker.toggle()
                        }
                    }
                    
                    SLabel(title: "End Date", text: dateFormatter.string(from: state.endDate ?? Date())) { [weak self] in
                        self?.state.isOpenEndDatePicker.toggle()
                    }
                    
                    if state.isOpenEndDatePicker {
                        SDatePicker(title: "End Date", date: state.endDate) { [self] endDate in
                            self.state.endDate = endDate
                            self.state.isOpenEndDatePicker.toggle()
                        }
                    }
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
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        print("Current State: \(state)")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        viewContext.perform {
            let goal = Goal(context: viewContext)
            goal.identifier = UUID()
            goal.name = self.state.name
            goal.desc = self.state.desc
            goal.iconName = self.state.iconName?.rawValue
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
            self.state.color?.getRed(&red, green: &green, blue: &blue, alpha: nil)
            goal.colorRed = Float(red)
            goal.colorGreen = Float(green)
            goal.colorBlue = Float(blue)
            goal.startDate = self.state.startDate
            goal.endDate = self.state.endDate
            
            let localCalendar = Locale.current.calendar
            var days = [Day]()
            for dayNum in 1 ... goal.endDate!.interval(ofComponent: .day, fromDate: goal.startDate!) {
                let day = Day(context: viewContext)
                day.identifier = UUID()
                day.number = Int16(dayNum)
                let thisDate = localCalendar.date(byAdding: .day, value: dayNum - 1, to: goal.startDate!)
                day.date = localCalendar.startOfDay(for: thisDate!)
                days.append(day)
            }
            goal.days = NSSet(array: days)
            
            appDelegate.saveContext()
        }
        
        dismiss(animated: true, completion: nil)
    }
}
