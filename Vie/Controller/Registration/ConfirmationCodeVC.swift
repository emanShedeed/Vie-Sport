//
//  ConfirmationCodeVCViewController.swift
//  Vie
//
//  Created by user137691 on 10/17/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import SwiftyJSON
class ConfirmationCodeVC: UIViewController {
    
    var mobile:String!{
        didSet{
            print(mobile)
        }
    }
    var UserObj:User?
    //Timer
    var countdownTimer: Timer!
    var totalTime = 60
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet var confirmationCodeTextFields: [UITextField]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        for textbox in confirmationCodeTextFields{
            textbox.setConfirmationTextFields()
            textbox.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
           textbox.keyboardType=UIKeyboardType.numberPad
           
        }
        confirmationCodeTextFields.sort{$0.tag<$1.tag}
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
        confirmationCodeTextFields.sort{$0.tag<$1.tag}
        //confirmationCodeTextFields[0].becomeFirstResponder()
    }
    
   @objc func textFieldDidChange(textField:UITextField) {
        let text=textField.text
        if (text?.count==1){
        switch textField {
        case confirmationCodeTextFields[0]:
            confirmationCodeTextFields[1].becomeFirstResponder()
        case confirmationCodeTextFields[1]:
            confirmationCodeTextFields[2].becomeFirstResponder()
        case confirmationCodeTextFields[2]:
            confirmationCodeTextFields[3].becomeFirstResponder()
        default:
            var confirmationCode=""
            for textField in confirmationCodeTextFields{
                confirmationCode=confirmationCode + (textField.text ?? "")
            }
          
           // APIsRequests().getData(from: "http://test100.revival.one/api/OwnersBusiness/ConfirmCode?", parameters: ["Mobile":String(mobile),"Code":String(confirmationCode)] )
            //    http://test100.revival.one/api/OwnersBusiness/ConfirmCode?////Mobile="+966569976080"&Code="5555"
            ConfirmCode(mobile:mobile,code:confirmationCode)
            break
        }
    }
    }
    func ConfirmCode(mobile:String,code:String){
        if let urlRequest = APIClient.Confirmcode(mobile: mobile, code: code){
            APIClient().jsonRequest(request: urlRequest) { (Json:Any?,statusCode:Int,ResponseMessageStatus:ResponseMessageStatusEnum?, userMessage:String?) -> (Void) in
                if let data = Json as? [String: Any]{
                    let status = data["Status"] as? String
                    if  status == "Success"{
                        self.AddUser()
                        self.performSegue(withIdentifier: "goToHomeVC", sender: self)
                    }
                    /*let messge=data["Message"] as? String
                    print(status as Any)
                    print(messge as Any)*/
                }
                
            }
        }
    }
    func AddUser(){
        if let  urlRequest=APIClient.AddUser(userObj: UserObj!){
            APIClient().jsonRequest(request: urlRequest) { (Json:Any?, statusCode:Int, ResponseMessageStatus:ResponseMessageStatusEnum?, userMessage:String?) -> (Void) in
                if let data=Json as? [String:Any]{
                    let status = data["Status"] as? String
                    let messge=data["Message"] as? String
                     print("add user status=\(status as Any)")
                    print(messge as Any)
                }
            }
        }
        
    }
    
    //MARK : - Timer
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        timerLabel.textColor=UIColor.orange
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        timerLabel.text="إضغط هنا"
        timerLabel.textColor=UIColor.white
        let tap=UITapGestureRecognizer(target: self, action: #selector(ResendConfirmationCode))
        timerLabel.addGestureRecognizer(tap)
        timerLabel.isUserInteractionEnabled=true
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    /*@objc func ResendConfirmationCode(){
        APIsRequests().getData(from: "http://test100.revival.one/api/OwnersBusiness/SendConfirmationCode?", parameters: ["Mobile":mobile])
        totalTime = 60
        startTimer()
        
    }*/
    @objc func ResendConfirmationCode(){
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
                        //self.performSegue(withIdentifier: "goToConfirmationCodeVC", sender: self)
                    }
                }
                
            })
        }
        totalTime = 60
        startTimer()
    }
}
