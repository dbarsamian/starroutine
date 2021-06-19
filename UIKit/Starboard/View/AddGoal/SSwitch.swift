//
//  SSwitch.swift
//  Starboard
//
//  Created by David Barsamian on 6/18/21.
//

import Carbon
import UIKit

struct SSwitch: IdentifiableComponent {
    var title: String
    var isOn: Bool
    var onSwitch: (Bool) -> Void
    
    var id: String {
        title
    }
    
    func renderContent() -> SSwitchContent {
        .loadFromNib()
    }
    
    func render(in content: SSwitchContent) {
        content.title.text = title
        content.switch.isOn = isOn
        content.onSwitch = onSwitch
    }
}

final class SSwitchContent: UIView, NibLoadable {
    @IBOutlet var title: UILabel!
    @IBOutlet var `switch`: UISwitch!
    var onSwitch: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.switch.addTarget(self, action: #selector(switched), for: .valueChanged)
    }
    
    @objc func switched() {
        onSwitch?(self.switch.isOn)
    }
}
