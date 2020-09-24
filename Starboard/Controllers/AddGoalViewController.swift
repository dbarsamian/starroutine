//
//  AddGoalViewController.swift
//  Starboard
//
//  Created by David Barsamian on 9/23/20.
//

import UIKit

// MARK: - AddGoalDelegate Protocol

protocol AddGoalDelegate {
    func addGoal(goal: Goal)
}

class AddGoalViewController: UITableViewController {
    
    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var DescriptionField: UITextField!
    
    var delegate: AddGoalDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        self.navigationItem.title = "Add Goal"
        
        
        TitleField.becomeFirstResponder()
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
