//
//  SignUpVC.swift
//  Vie
//
//  Created by gody on 10/10/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import GoogleSignIn
class SignUpVC: UIViewController ,GIDSignInUIDelegate {
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for textfield in textFields{
            textfield.setBottomBorder()
        }
        self.hideKeyboardWhenTappedAround()


    }

    // MARK :- Google Login
    @IBAction func googleSgninBtnPressed(_ sender: Any) {
        //GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
}
