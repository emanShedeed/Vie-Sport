//
//  Validate.swift
//  Vie
//
//  Created by user137691 on 11/7/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class ValidateSignUpTextFields: UIViewController {
    typealias completionHandler = (_ status:Bool?) -> (Void)
    var signUptextFields:[UITextField]!
    var signUpvalidationLabels:[UILabel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func initArrays(textFieldsArray:[UITextField],validationlabelsArray:[UILabel],view:UITextFieldDelegate) {
        signUptextFields=textFieldsArray
        signUpvalidationLabels=validationlabelsArray
        //loop through all textfields to set customize border
        for textfield in signUptextFields{
            textfield.setBottomBorder()
            textfield.delegate=view
        }
        //To hide keyboard
        self.hideKeyboardWhenTappedAround()
    }
    
    func validateEmail(textFields:[UITextField],validationLabels:[UILabel],compltionHandler:@escaping completionHandler){
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
                APIClient().jsonRequest(request: request, CompletionHandler: { (JSON: Any?, statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                    
                    if let  data = JSON as? [String: Any]{
                        let status=data["Status"] as! String
                        if (status=="Success"){
                            let mobileTextField=textFields[3]
                            // if email is valid send confirmation code
                            self.SendConfirmationCode(mobile: mobileTextField.text!, completion: { (result) -> (Void) in
                                compltionHandler(result)
                                
                            })
                        }
                    }
                })
            }
        }
        
    }
    
    func SendConfirmationCode(mobile:String,completion:@escaping completionHandler){
        var isSucess=false
        //  APIsRequests().getData(from: "http://test100.revival.one/api/OwnersBusiness/SendConfirmationCode?", parameters: ["Mobile":mobileTextField.text ?? ""])
        if let request = APIClient.SendConfirmationCode(mobile: mobile){
            APIClient().jsonRequest(request: request, CompletionHandler: { (JSON: Any?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                
                if let  data = JSON as? [String: Any]{
                    print ("Final Result= \(String(describing: data["Status"] ))")
                    let status=data["Status"] as? String
                    if (status=="Success"){
                        
                        print("successfuly send Confirmation Code")
                        /*let messageAlert = UIAlertController.init(title: "", message: data["Message"], preferredStyle: .alert)
                         let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                         messageAlert.addAction(action)
                         self.present(messageAlert,animated: true,completion: nil)*/
                        isSucess=true
                        completion(isSucess)
                        
                    }
                }
                
            })
        }
    }
    
   
    
}
extension ValidateSignUpTextFields:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case signUptextFields[0]:
            let (valid, message) = validate(textField)
            
            if valid {
                signUptextFields[1].becomeFirstResponder()
            }
            
            // Update Password Validation Label
            signUpvalidationLabels[0].text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.signUpvalidationLabels[0].isHidden = valid
            })
        case signUptextFields[1]:
            let (valid, message) = validate(textField)
            
            if valid {
                signUptextFields[2].becomeFirstResponder()
            }
            
            // Update Password Validation Label
            signUpvalidationLabels[1].text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.signUpvalidationLabels[1].isHidden = valid
            })
            
        case signUptextFields[2]:
            let (valid, message) = validate(textField)
            
            if valid {
                signUpvalidationLabels[3].becomeFirstResponder()
            }
            
            // Update Password Validation Label
            signUpvalidationLabels[2].text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.signUpvalidationLabels[2].isHidden = valid
            })
            
        default:
            let (valid, message) = validate(textField)
            
            if valid {
                signUptextFields[3].resignFirstResponder()
            }
            
            // Update Password Validation Label
            signUpvalidationLabels[3].text = message
            
            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.signUpvalidationLabels[3].isHidden = valid
            })
        }
        return true
    }
    // MARK: - Helper Methods
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        
        if textField == signUptextFields[1] {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return ( emailTest.evaluate(with:textField.text), "Invalid Email Address.")
        }
        if textField == signUptextFields[2] {
            return (text.count >= 6, "Your password is too short.")
        }
        if textField==signUptextFields[3]{
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
