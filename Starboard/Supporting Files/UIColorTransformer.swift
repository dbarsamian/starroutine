//
//  UIColorTransformer.swift
//  Starboard
//
//  Created by David Barsamian on 1/15/21.
//
//  NOTE: This code was adapted from https://www.kairadiagne.com/2020/01/13/nssecurecoding-and-transformable-properties-in-core-data.html

import Foundation
import UIKit

@objc(UIColorValueTransformer)
final class UIColorTransformer: NSSecureUnarchiveFromDataTransformer {
    
    // The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTransformer(_"forName:)`
    static let name = NSValueTransformerName(rawValue: String(describing: UIColorTransformer.self))
    
    // Make sure UIColor is in the allowed class list.
    override static var allowedTopLevelClasses: [AnyClass] {
        return [UIColor.self]
    }
    
    // Register the Transformer
    public static func register() {
        let transformer = UIColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
    
}
