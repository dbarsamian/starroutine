//
//  SIconLabel.swift
//  Starboard
//
//  Created by David Barsamian on 6/18/21.
//

import Carbon
import UIKit

struct SIconLabel: IdentifiableComponent {
    var title: String
    var image: UIImage?
    var color: UIColor?
    var onSelect: () -> Void
    
    var id: String {
        title
    }
    
    func renderContent() -> SIconLabelContent {
        .loadFromNib()
    }
    
    func render(in content: SIconLabelContent) {
        content.titleLabel.text = title
        content.imageView.image = image
        content.imageView.tintColor = color
        content.onSelect = onSelect
    }
}

final class SIconLabelContent: UIControl, NibLoadable {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
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
