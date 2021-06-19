//
//  SColorPicker.swift
//  Starboard
//
//  Created by David Barsamian on 6/18/21.
//

import Carbon
import SnapKit
import UIKit

struct SColorPicker: Component {
    var title: String
    var color: UIColor?
    var onInput: (UIColor?) -> Void
    
    init(title: String, color: UIColor?, onInput: @escaping (UIColor?) -> Void) {
        self.title = title
        self.color = color
        self.onInput = onInput
    }
    
    func renderContent() -> SColorPickerContent {
        .loadFromNib()
    }
    
    func render(in content: SColorPickerContent) {
        content.titleLabel.text = title
        content.colorWell.selectedColor = color
        content.onInput = onInput
    }
}

final class SColorPickerContent: UIView, NibLoadable, UIColorPickerViewControllerDelegate {
    @IBOutlet var titleLabel: UILabel!
    var colorWell: UIColorWell!

    var onInput: ((UIColor?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorWell = UIColorWell(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        self.addSubview(colorWell)
        colorWell.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
            make.centerY.equalTo(self)
            make.trailing.greaterThanOrEqualTo(self)
        }
        colorWell.addTarget(self, action: #selector(input), for: .valueChanged)
    }
    
    @objc func input() {
        onInput?(colorWell.selectedColor)
    }
}
