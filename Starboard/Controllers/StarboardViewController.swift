//
//  StarboardViewController.swift
//  Starboard
//
//  Created by David Barsamian on 9/23/20.
//

import UIKit
import RealmSwift

class StarboardViewController: UIViewController {
    
    // Data
    var goal: Goal?
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setAppearance() {
        switch preferredStatusBarStyle {
        case .darkContent:
            navigationController?.navigationItem.leftBarButtonItem?.tintColor = .black
            navigationController?.navigationItem.rightBarButtonItem?.tintColor = .black
            break
        case .lightContent:
            navigationController?.navigationItem.leftBarButtonItem?.tintColor = .white
            navigationController?.navigationItem.rightBarButtonItem?.tintColor = .white
            break
        default:
            break
        }
    }

}

extension StarboardViewController: UITableViewDelegate {
    
}

extension StarboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goal?.datesCompleted.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.StarboardCellIdentifier, for: indexPath) as! StarboardCell
        if let safeGoal = goal {
            cell.titleLabel.text = "Day \(indexPath.row)"
            
        }
        return cell
    }
    
    
}
