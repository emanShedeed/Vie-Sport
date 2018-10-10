//
//  SignUpVC.swift
//  Vie
//
//  Created by gody on 10/10/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet var textFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for textfield in textFields{
            textfield.setBottomBorder()
            
        }
    }



 
}
