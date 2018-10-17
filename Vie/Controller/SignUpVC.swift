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
class SignUpVC: UIViewController ,GIDSignInUIDelegate {
    //MARK : - Declare IBoutlet
    @IBOutlet var textFields: [UITextField]!
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
        //Add observer to get status of an API
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveEmailStatus(_:)), name: .didCheckEmailStatus , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidSendConfirmationCode(_:)), name: .didSendConfirmationCode , object: nil)    }

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
    //MARK :-
    @IBAction func SignUpButtonPressed(_ sender: Any) {
   APIsRequests().getStatus(from: "http://test100.revival.one/api/users/CheckEmail?", parameters: ["Email":"eman.shedeed2013@gmail.com"])
        
        //let result=APIsRequests().parseData(json: json)
       // print("Final Result\(result)")
    }
   // @objc func onDidReceiveStatus
    @objc func onDidReceiveEmailStatus(_ notification:NSNotification){
        if let data = notification.userInfo as? [String: String]
        {
            print ("Final Result= \(data["Status"] ?? nil!)")
            let status=data["Status"]
            if (status=="Success"){
                textFields.sort{$0.tag<$1.tag}
                let mobileTextField=textFields[3]
               // print(mobileTextField.text ?? "")
                APIsRequests().getData(from: "http://test100.revival.one/api/OwnersBusiness/SendConfirmationCode?", parameters: ["Mobile":mobileTextField.text ?? ""])
            }
        }
        
    }
    func parseData(json :JSON){
       // print (json)
        let Result = String(json[]["Status"].stringValue)
        let Messge=String(json[]["Message"].stringValue)
        NotificationCenter.default.post(name:.didSendConfirmationCode, object: self , userInfo: ["Status":Result,"Message":Messge] as [AnyHashable : Any])
        
    }
   @objc func onDidSendConfirmationCode(_ notification:NSNotification){
        if let data = notification.userInfo as? [String: String]
        {
            let status=data["Status"]
            if (status=="Success"){
                /*let messageAlert = UIAlertController.init(title: "", message: data["Message"], preferredStyle: .alert)
                let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                messageAlert.addAction(action)
                self.present(messageAlert,animated: true,completion: nil)*/
                performSegue(withIdentifier: "goToConfirmationCodeVC", sender: self)
               
                
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! ConfirmationCodeVC
        destinationVC.mobile=textFields[3].text!
    }
}
