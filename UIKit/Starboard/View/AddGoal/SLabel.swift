//
//  SLabel.swift
//  Starboard
//
//  Created by David Barsamian on 6/18/21.
//

import Carbon
import UIKit

struct SLabel: IdentifiableComponent {
    var title: String
    var text: String?
    var onSelect: () -> Void
    
    var id: String {
        title
    }
    
    func renderContent() -> SLabelContent {
        .loadFromNib()
    }
    
    func render(in content: SLabelContent) {
        content.titleLabel.text = title
        content.textLabel.text = text
        content.onSelect = onSelect
    }
}

final class SLabelContent: UIControl, NibLoadable {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    
    var onSelect: (() -> Void)?
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .systemGray4 : .systemBackground
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTarget(self, action: #selector(selected), for: .touchUpInside)
    }
    
    @objc func selected() {
        onSelect?()
    }
}
