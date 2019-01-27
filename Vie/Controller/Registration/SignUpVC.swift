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
    var fbLoginSuccess=false
    var activeTextField=UITextField()
    var socialData=[String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden=true
      
        //sort textfields by target id
        textFields.sort{$0.tag<$1.tag}
        //sort validationLabels by target id
        validationLabels.sort{$0.tag<$1.tag}
        
        //loop through all textfields to set customize border
        for textfield in textFields{
            textfield.setBottomBorder(color: UIColor.white)
            textfield.delegate=self
        }
        
        //To hide keyboard
        self.hideKeyboardWhenTappedAround()
        
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
            for (title, value) in data
            {
                print("\(title) : \(value) ")
            }
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
                        for (title, value) in dict
                        {
                            print("\(title) : \(value) ")
                        }
                        self.socialData=dict
                        self.socialData.updateValue("FB", forKey:"loginType")
                        
                    }
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
            // APIsRequests().getStatus(from: "http://test100.revival.one/api/users/CheckEmail?", parameters: ["Email":textFields[1].text!])
            if let request = APIClient.CheckEmail(email: textFields[1].text!){
              
                APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?, statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                    
                    if let  data = JsonValue{
                        let status=data["Status"]
                        if (status=="Success"){
                            let mobileTextField=self.textFields[3]
                            // if email is valid send confirmation code
                            self.SendConfirmationCode(mobile: mobileTextField.text!)
                        }
                    }
                  
                })
            }
        }
    }
    func SendConfirmationCode(mobile:String){
        //  APIsRequests().getData(from: "http://test100.revival.one/api/OwnersBusiness/SendConfirmationCode?", parameters: ["Mobile":mobileTextField.text ?? ""])
        if let request = APIClient.SendConfirmationCode(mobile: mobile){
            APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                
                if let  data = JsonValue{
                    let status=data["Status"]
                    if (status=="Success"){
                        
                        print("successfuly send Confirmation Code")
                        /*let messageAlert = UIAlertController.init(title: "", message: data["Message"], preferredStyle: .alert)
                         let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                         messageAlert.addAction(action)
                         self.present(messageAlert,animated: true,completion: nil)*/
                        self.performSegue(withIdentifier: "goToConfirmationCodeVC", sender: self)
                    }
                }
                
            })
        }
    }
    
    @IBAction func SkipButtonPressed(_ sender: Any?) {
        performSegue(withIdentifier: "goToHomeVC", sender: self)
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
            destinationVC.UserObj=User(userEmail:textFields[1].text!, userPassword: textFields[2].text!, userFullName:textFields[0].text!, userMobile: textFields[3].text!, userOperatingSystem: "IOS", userSocialType: "", userSocialUserID: "", UserDeviceToken: "", userImageLocation: "")
        }
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
                validationLabels[3].becomeFirstResponder()
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
            var PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
            var phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: textField.text)
            if(result)
            {
                textField.text="+966"+textField.text!
            }
            PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$";
            phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            return(phoneTest.evaluate(with: textField.text ),"Invalid Mobile Number")
            
        }
        
        return (text.count > 0, "This field cannot be empty.")
    }
}
