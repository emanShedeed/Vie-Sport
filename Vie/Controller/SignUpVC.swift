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
import SwiftyJSON
class SignUpVC: ValidateSignUpTextFields ,GIDSignInUIDelegate{
    //MARK : - Declare IBoutlet
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet var validationLabels: [UILabel]!
    
    // MARK : - Declare constants
    var fbLoginSuccess=false
    var activeTextField=UITextField()
    var socialData=[String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        //sort textfields by target id
        textFields.sort{$0.tag<$1.tag}
        //sort validationLabels by target id
        validationLabels.sort{$0.tag<$1.tag}
        initArrays(textFieldsArray: textFields, validationlabelsArray: validationLabels, view: self as UITextFieldDelegate)
        //change keyboard style ->from story board
       // textFields[1].keyboardType=UIKeyboardType.emailAddress
       // textFields[3].keyboardType=UIKeyboardType.phonePad
    }
    override func viewWillAppear(_ animated: Bool) {
        // Add observer To obtain google Data
        NotificationCenter.default.setObserver(self, selector: #selector(onDidReceiveGoogleUserInfo(_:)), name: .didReceiveGoogleData, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true)
        {
           performSegue(withIdentifier: "goToSocialSignUpVC", sender:self)
        }
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
            socialData=data
        socialData.updateValue("GO", forKey:"loginType")
            /* for (title, value) in data
            {
                print("\(title) : \(value) ")
            }*/
        }
        performSegue(withIdentifier: "goToSocialSignUpVC", sender:self)
    }
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
                    self.fbLoginSuccess=true
                    //everything works print the user data
                    print("FB Login Data:\(result ?? "can not Get FB Data")")
                    if let dict=result as? [String:Any]{
                        self.socialData=dict
                        self.socialData.updateValue("FB", forKey:"loginType")
                        
                    }
                }
            })
        }
    }
    //MARK :-
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        validateEmail(textFields: textFields, validationLabels: validationLabels) { (isConfirmationCodeSent) -> (Void) in
            if(isConfirmationCodeSent ?? false){
                self.performSegue(withIdentifier: "goToConfirmationCodeVC", sender: self)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToSocialSignUpVC")
        {
            let destinationVC=segue.destination as! SocialSignUpVC
            destinationVC.socialData=socialData
        }
        else if (segue.identifier=="goToConfirmationCodeVC"){
        let destinationVC=segue.destination as! ConfirmationCodeVC
        destinationVC.mobile=textFields[3].text!
        }
    }
}
