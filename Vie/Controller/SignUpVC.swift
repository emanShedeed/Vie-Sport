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
class SignUpVC: UIViewController ,GIDSignInUIDelegate{
    //MARK : - Declare IBoutlet
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet var validationLabels: [UILabel]!
    
    // MARK : - Declare constants
    var activeTextField=UITextField()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //loop through all textfields to set customize border
        for textfield in textFields{
            textfield.setBottomBorder()
            textfield.delegate=self
        }
        //To hide keyboard
        self.hideKeyboardWhenTappedAround()
        //sort textfields by target id
        textFields.sort{$0.tag<$1.tag}
        //sort validationLabels by target id
        validationLabels.sort{$0.tag<$1.tag}
        // Add observer To obtain google Data
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveGoogleUserInfo(_:)), name: .didReceiveGoogleData, object: nil)
        //Add observer to get status of an API
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveEmailStatus(_:)), name: .didCheckEmailStatus , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidSendConfirmationCode(_:)), name: .didSendConfirmationCode , object: nil)
        //change keyboard style ->from story board
       // textFields[1].keyboardType=UIKeyboardType.emailAddress
       // textFields[3].keyboardType=UIKeyboardType.phonePad
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
    //MARK :-
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        var isCompleted=true
        for (index,textField) in textFields.enumerated(){
            let (valid, message) = validate(textField)
            validationLabels[index].isHidden=valid
            validationLabels[index].text=message
            if(!valid){
                isCompleted=false
                break
            }

        }
        if isCompleted{
        APIsRequests().getStatus(from: "http://test100.revival.one/api/users/CheckEmail?", parameters: ["Email":textFields[1].text!])
        }
    }
   // @objc func onDidReceiveStatus
    @objc func onDidReceiveEmailStatus(_ notification:NSNotification){
        if let data = notification.userInfo as? [String: String]
        {
            print ("Final Result= \(data["Status"] ?? nil!)")
            let status=data["Status"]
            if (status=="Success"){
               
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
extension SignUpVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textFields[0]:
            let (valid, message) = validate(textField)
            
            if valid {
                textFields[1].becomeFirstResponder()
            }
            
            // Update Password Validation Label
            validationLabels[0].text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.validationLabels[0].isHidden = valid
            })
        case textFields[1]:
            let (valid, message) = validate(textField)
            
            if valid {
                textFields[2].becomeFirstResponder()
            }
            
            // Update Password Validation Label
            validationLabels[1].text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.validationLabels[1].isHidden = valid
            })
            
        case textFields[2]:
            let (valid, message) = validate(textField)
            
            if valid {
                textFields[3].becomeFirstResponder()
            }
            
            // Update Password Validation Label
            validationLabels[2].text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.validationLabels[2].isHidden = valid
            })
            
        default:
            let (valid, message) = validate(textField)
            
            if valid {
                textFields[3].resignFirstResponder()
            }
            
            // Update Password Validation Label
            validationLabels[3].text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.validationLabels[3].isHidden = valid
            })
        }
        return true
    }
    // MARK: - Helper Methods
    
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        if textField == textFields[1] {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return ( emailTest.evaluate(with:textField.text), "Invalid Email Address.")
        }
        if textField == textFields[2] {
            return (text.count >= 6, "Your password is too short.")
        }
        if textField==textFields[3]{
            var completedPhoneNumber=textField.text
            var PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
            var phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: textField.text)
            if(result)
            {
                 completedPhoneNumber="+966"+textField.text!
            }
             PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$";
             phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            return(phoneTest.evaluate(with: completedPhoneNumber ),"Invalid Mobile Number")

        }
        
        return (text.count > 0, "This field cannot be empty.")
    }
}
