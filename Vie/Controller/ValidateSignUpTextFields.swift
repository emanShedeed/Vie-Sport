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
      
    }
    
   
    }
    
    func SendConfirmationCode(mobile:String){
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
