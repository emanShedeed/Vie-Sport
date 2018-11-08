//
//  SocialSIgnUpVC.swift
//  Vie
//
//  Created by user137691 on 11/6/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class SocialSignUpVC:UIViewController{
    
    var socialData:[String:Any]?
    
    @IBOutlet var socialSinUpTextFields:[UITextField]!
    @IBOutlet var validationLabels:[UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //sort textfields by target id
        socialSinUpTextFields.sort{$0.tag<$1.tag}
        //sort validationLabels by target id
        validationLabels.sort{$0.tag<$1.tag}
        
        //loop through all textfields to set customize border
        for textfield in socialSinUpTextFields{
            textfield.setBottomBorder()
            textfield.delegate=self
        }
        
        //To hide keyboard
        self.hideKeyboardWhenTappedAround()
        
        //display social data
        if let data=socialData{
            displayData(dict: data)
        }
    }
    
    func displayData(dict:[String:Any]){
            if let name=dict["name"] as? String{
            socialSinUpTextFields[0].text=name
        }
        if let email=dict["email"] as? String{
            socialSinUpTextFields[1].text=email
        }
        /*if let loginType=dict["loginType"]as? String{
            socialSinUpTextFields[3].text=loginType
        }*/
        
    }
    
    @IBAction func SocialSignUpButtonPressed(_ sender: Any) {
        var isCompleted=true
        for (index,textField) in socialSinUpTextFields.enumerated(){
            let (valid, message) = validate(textField)
            validationLabels[index].isHidden=valid
            validationLabels[index].text=message
            if(!valid){
                isCompleted=false
                break
            }
        }
        if isCompleted{
            // APIsRequests().getStatus(from: "http://test100.revival.one/api/users/CheckEmail?", parameters: ["Email":socialSinUpTextFields[1].text!])
            if let request = APIClient.CheckEmail(email: socialSinUpTextFields[1].text!){
                APIClient().jsonRequest(request: request, CompletionHandler: { (JSON: Any?, statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                    
                    if let  data = JSON as? [String: Any]{
                        let status=data["Status"] as! String
                        if (status=="Success"){
                            let mobileTextField=self.socialSinUpTextFields[3]
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
            APIClient().jsonRequest(request: request, CompletionHandler: { (JSON: Any?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                
                if let  data = JSON as? [String: Any]{
                    let status=data["Status"] as? String
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! ConfirmationCodeVC
            destinationVC.mobile=socialSinUpTextFields[3].text!
        
    }}
extension SocialSignUpVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case socialSinUpTextFields[0]:
            let (valid, message) = validate(textField)
            
            if valid {
                socialSinUpTextFields[1].becomeFirstResponder()
            }
            
            // Update Password Validation Label
            validationLabels[0].text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.validationLabels[0].isHidden = valid
            })
        case socialSinUpTextFields[1]:
            let (valid, message) = validate(textField)
            
            if valid {
                socialSinUpTextFields[2].becomeFirstResponder()
            }
            
            // Update Password Validation Label
            validationLabels[1].text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.validationLabels[1].isHidden = valid
            })
            
        case socialSinUpTextFields[2]:
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
                socialSinUpTextFields[3].resignFirstResponder()
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
        
        if textField == socialSinUpTextFields[1] {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return ( emailTest.evaluate(with:textField.text), "Invalid Email Address.")
        }
        if textField == socialSinUpTextFields[2] {
            return (text.count >= 6, "Your password is too short.")
        }
        if textField==socialSinUpTextFields[3]{
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
