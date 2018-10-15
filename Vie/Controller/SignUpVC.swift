//
//  SignUpVC.swift
//  Vie
//
//  Created by gody on 10/10/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import GoogleSignIn
class SignUpVC: UIViewController , GIDSignInUIDelegate{

    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for textfield in textFields{
            textfield.setBottomBorder()
        }
        self.hideKeyboardWhenTappedAround()
        //MARK: - google login
        GIDSignIn.sharedInstance().uiDelegate = self
       signInButton.style = .iconOnly
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        //MARK :- facebook login

    }


   
}
