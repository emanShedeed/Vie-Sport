//
//  AddingPlayGround5_InfoVC.swift
//  Vie
//
//  Created by user137691 on 1/14/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit
import SwiftyJSON
class AddingPlayGround5_InfoVC: UIViewController,UITextFieldDelegate {
    var playGroundInfoDict=[String:Any]()
    
    @IBOutlet var playGroundInfoTextFields: [UITextField]!
    
    @IBOutlet var validationLabels: [UILabel]!
    
    @IBOutlet weak var remarksTxtView: UITextView!
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        for textField in playGroundInfoTextFields{
            textField.delegate=self
            textField.setBottomBorder(color: UIColor.darkGray)
        }
        playGroundInfoTextFields.sort{$0.tag<$1.tag}
        validationLabels.sort{$0.tag<$1.tag}
    }
    
    @IBAction func SaveButtonPressed(_ sender: Any) {
        var isCompleted=true
        for (index,textField) in playGroundInfoTextFields.enumerated(){
            let (valid, message) = validate(textField)
            validationLabels[index].isHidden=valid
            validationLabels[index].text=message
            if(!valid){
                isCompleted=false
                break
            }
        }
        if isCompleted{
            playGroundInfoDict["PlayGroundName"]=playGroundInfoTextFields[0].text
            playGroundInfoDict["ResbonsibleName"]=playGroundInfoTextFields[1].text
            playGroundInfoDict["ContactNumber"]=playGroundInfoTextFields[2].text
            playGroundInfoDict["Price"]=playGroundInfoTextFields[3].text
            playGroundInfoDict["Remarks"]=remarksTxtView.text
            if(HelperMethods.IsKeyPresentInUserDefaults(key: "AccessToken")){
                var accessToken=UserDefaults.standard.value(forKey: "AccessToken") as! String
                accessToken="Guest"
                if let request = APIClient.AddPlayGround(accessToken: accessToken, dict: playGroundInfoDict){
                    
                    APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?, statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                        
                        if let  data = JsonValue{
                            let status=data["Status"]
                            if (status=="Success"){
                                print("successed to add playGround")
                            }
                        }
                        
                    })
                }
            }
        }
    }
    // MARK: - Helper Methods
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        if textField==playGroundInfoTextFields[2]{
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

