//
//  UITextFieldExtension.swift
//  Vie
//
//  Created by user137691 on 12/30/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
import UIKit
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
