//
//  SignUpVC.swift
//  Vie
//
//  Created by gody on 10/10/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import GoogleSignIn
import NotificationCenter
class SignUpVC: UIViewController ,GIDSignInUIDelegate {
    //MARK : - Declare IBoutlet
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var signInButton: GIDSignInButton!
    //MARK : - Notification center
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //loop through all textfields to set customize border
        for textfield in textFields{
            textfield.setBottomBorder()
        }
        //To hide keyboard
        self.hideKeyboardWhenTappedAround()
        
        // Add observer To obtain google Data
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveGoogleUserInfo(_:)), name: .didReceiveGoogleData, object: nil)
    }

    // MARK :- Google Login
    @IBAction func googleSgninBtnPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    //MARK : - Get google Login Info
    @objc func onDidReceiveGoogleUserInfo(_ notification:NSNotification){
        if let data = notification.userInfo as? [String: String]
        {
            for (title, value) in data
            {
                print("\(title) : \(value) ")
            }
        }    }
    
    
}
