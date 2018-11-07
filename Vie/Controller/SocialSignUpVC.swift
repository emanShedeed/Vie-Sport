//
//  SocialSIgnUpVC.swift
//  Vie
//
//  Created by user137691 on 11/6/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class SocialSignUpVC:ValidateSignUpTextFields{
    
    var socialData:[String:Any]?

    @IBOutlet var socialSinUpTextFields:[UITextField]!
    @IBOutlet var validationLabels:[UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        socialSinUpTextFields.sort{$0.tag<$1.tag}
        //sort validationLabels by target id
        validationLabels.sort{$0.tag<$1.tag}
        if let data=socialData{
        displayData(dict: data)
        }
        // Do any additional setup after loading the view.
        initArrays(textFieldsArray: socialSinUpTextFields, validationlabelsArray: validationLabels, view: self as UITextFieldDelegate)
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
        validateEmail(textFields: socialSinUpTextFields, validationLabels: validationLabels) { (isConfirmationCodeSent) -> (Void) in
            if(isConfirmationCodeSent ?? false){
                self.performSegue(withIdentifier: "goToConfirmationCodeVC", sender: self)
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! ConfirmationCodeVC
            destinationVC.mobile=socialSinUpTextFields[3].text!
        
    }}
