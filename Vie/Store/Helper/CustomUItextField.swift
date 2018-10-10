//
//  CustomUItextField.swift
//  Vie
//
//  Created by gody on 10/10/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class CustomUItextField: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        //self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
