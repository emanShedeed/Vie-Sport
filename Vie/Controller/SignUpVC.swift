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
import FBSDKLoginKit
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
    //MARK : - FB login
    @IBAction func loginFacebookAction(sender: AnyObject) {//action of the custom button in the storyboard
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print("FB Login Data:\(result ?? "can not Get FB Data")")
                }
            })
        }
    }
}
