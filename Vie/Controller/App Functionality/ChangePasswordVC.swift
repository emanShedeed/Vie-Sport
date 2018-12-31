//
//  ChangePasswordVC.swift
//  Vie
//
//  Created by user137691 on 12/30/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import SwiftyJSON
class ChangePasswordVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var currentPasswordTxt: UITextField!
    
    @IBOutlet weak var newPasswordTxt: UITextField!
    
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    
    @IBOutlet var validationLabels: [UILabel]!
    var textFields=[UITextField]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        validationLabels.sort{$0.tag<$1.tag}
        self.hideKeyboardWhenTappedAround()
        textFields=[currentPasswordTxt,newPasswordTxt,confirmPasswordTxt]
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden=true
    }
    
    @IBAction func SaveButtonPressed(_ sender: Any) {
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
            ChangePassword()
        }
    }
    func ChangePassword(){
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "UserID"))
        {
            let userID=UserDefaults.standard.integer(forKey: "UserID")
            if let request = APIClient.ChangePassword(userID: userID, oldPassword: currentPasswordTxt.text!, newPassword: newPasswordTxt.text!){
                APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                    
                    if let  data = JsonValue{
                        let status=data["Status"]
                        if (status=="Success"){
                            print("successfuly change Password")
                        }
                        else if (status=="Error"){
                            self.validationLabels[0].isHidden=false
                            self.validationLabels[0].text=data["Message"].string
                        }
                        
                    }
                    
                })
            }
        }
    }
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
        default:
            let (valid, message) = validate(textField)
            
            if valid {
                textFields[2].resignFirstResponder()
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
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        if textField == textFields[1] {
            return (text.count >= 6, "Your password is too short.")
        }
        if textField==textFields[2]{
            return (text==textFields[1].text, "Your password is Not the same.")
        }
        return (text.count > 0, "This field cannot be empty.")
    }}
