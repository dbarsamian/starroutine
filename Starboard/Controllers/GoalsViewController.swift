//
//  GoalsViewController.swift
//  Starboard
//
//  Created by David Barsamian on 9/23/20.
//

import UIKit
import RealmSwift

// MARK: - UIViewController
class GoalsViewController: UITableViewController {
    
    var realm: Realm?
    var goals: Results<Goal>? {
        willSet {
            print("\(Date()): About to retrieve goals list.")
        }
        didSet {
            print("\(Date()): Retrieved goals list.")
            tableView.reloadData(with: .automatic)
        }
    } // Table view reloads when goals is set

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get reference to singleton Realm
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        realm = appDelegate.realm
        
        // Retrieve goals
        goals = loadGoals()
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.AddGoalSegueIdentifier, sender: self)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let naviVC = segue.destination as? UINavigationController {
            if let destVC = naviVC.viewControllers[0] as? AddGoalViewController {
                destVC.delegate = self
            } else {
                print("Could not find add goal view controller")
            }
        } else {
            print("Could not find navigation controller")
        }
    }
    
    // MARK: - Data Manipulation
    func saveGoals() {
        
    }
    
    func loadGoals() -> Results<Goal>? {
        return realm?.objects(Goal.self)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.GoalCellIdentifier)!
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
    }
    

}

extension GoalsViewController: AddGoalDelegate {
    func addGoal(goal: Goal) {
        self.dismiss(animated: true) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy h:mm a"
            print("\(goal.title): \(goal.description) @ \(formatter.string(from: goal.dateCreated! ))")
        }
    }
}
