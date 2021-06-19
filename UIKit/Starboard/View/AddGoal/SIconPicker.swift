//
//  SIconPicker.swift
//  Starboard
//
//  Created by David Barsamian on 6/18/21.
//

import Carbon
import UIKit

struct SIconPicker: Component {
    var icons: [Icon]
    var color: UIColor?
    var onSelect: (String) -> Void
    
    func renderContent() -> SIconPickerContent {
        .loadFromNib()
    }
    
    func render(in content: SIconPickerContent) {
        content.icons = icons
        content.tintColor = color
        content.onSelect = onSelect
    }
    
    func shouldRender(next: SIconPicker, in content: SIconPickerContent) -> Bool {
        icons != next.icons
    }
}

final class SIconPickerContent: UIView, NibLoadable, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var pickerView: UIPickerView! {
        didSet {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
    
    var icons = [Icon]() {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    var onSelect: ((String) -> Void)?
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        icons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var image = UIImage(systemName: icons[row].rawValue)
        image = image?.applyingSymbolConfiguration(.init(scale: .large))
        let view = UIImageView(image: image)
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onSelect?(icons[row].rawValue)
    }
    
    
}
