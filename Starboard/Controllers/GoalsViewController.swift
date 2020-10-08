//
//  GoalsViewController.swift
//  Starboard
//
//  Created by David Barsamian on 9/23/20.
//

import RealmSwift
import UIKit

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
        performSegue(withIdentifier: Constants.SegueIdentifier.AddGoalSegueIdentifier, sender: self)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {}
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.SegueIdentifier.AddGoalSegueIdentifier:
            if let naviVC = segue.destination as? UINavigationController {
                if let destVC = naviVC.viewControllers[0] as? AddGoalViewController {
                    destVC.delegate = self
                } else {
                    print("Could not find add goal view controller")
                }
            } else {
                print("Could not find navigation controller")
            }
        case Constants.SegueIdentifier.StarboardSegueIdentifier:
            if let destVC = segue.destination as? StarboardViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if let safeGoals = goals {
                        destVC.goal = safeGoals[indexPath.row]
                    }
                }
            }
        default:
            print("Default case reached!!!")
        }
    }
    
    // MARK: - Data Manipulation

    func saveGoal(_ goal: Goal) {
        do {
            try realm?.write {
                realm?.add(goal)
            }
        } catch {
            print(error)
        }
        tableView.reloadData(with: .automatic)
    }
    
    func loadGoals() -> Results<Goal>? {
        return realm?.objects(Goal.self)
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.GoalCellIdentifier)!
        if let safeGoals = goals {
            cell.textLabel?.text = safeGoals[indexPath.row].title
            cell.detailTextLabel?.text = safeGoals[indexPath.row].goalDescription
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.SegueIdentifier.StarboardSegueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension GoalsViewController: AddGoalDelegate {
    func addGoal(goal: Goal) {
        dismiss(animated: true) {
            self.saveGoal(goal)
        }
    }
}
