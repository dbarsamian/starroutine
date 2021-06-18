//
//  STextField.swift
//  Starboard
//
//  Created by David Barsamian on 6/17/21.
//

import Carbon
import UIKit

struct STextField: IdentifiableComponent {
    var title: String
    var text: String?
    var placeholderText: String?
    var keyboardType: UIKeyboardType
    var onInput: (String?) -> Void
    
    init(title: String, text: String?, placeholder: String? = nil, keyboardType: UIKeyboardType = .default, onInput: @escaping (String?) -> Void) {
        self.title = title
        self.text = text
        self.placeholderText = placeholder
        self.keyboardType = keyboardType
        self.onInput = onInput
    }
    
    var id: String {
        title
    }
    
    func renderContent() -> STextFieldContent {
        .loadFromNib()
    }
    
    func render(in content: STextFieldContent) {
        if !content.textField.isFirstResponder {
            content.textField.text = text
        }
        
        content.title.text = title
        content.textField.keyboardType = keyboardType
        content.onInput = onInput
        content.textField.placeholder = placeholderText
    }
}

final class STextFieldContent: UIControl, NibLoadable {
    @IBOutlet var title: UILabel!
    @IBOutlet var textField: UITextField!
    
    var onInput: ((String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTarget(self, action: #selector(selected), for: .touchUpInside)
        textField.addTarget(self, action: #selector(input), for: .allEditingEvents)
    }
    
    @objc func selected() {
        textField.becomeFirstResponder()
    }
    
    @objc func input() {
        onInput?(textField.text)
    }
}
