//
//  ProfilePersonalInfoVC.swift
//  Vie
//
//  Created by user137691 on 12/25/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProfilePersonalInfoVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var personalImageTxt: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var FullNametxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var Mobiletxt: UITextField!
    
    @IBOutlet weak var errorLbl: UILabel!
    var textFields=[UITextField]()
    var  imagePicker=UIImagePickerController()
    var personalImage=UIImage()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        personalImageTxt.delegate=self
        textFields=[FullNametxt,emailTxt,Mobiletxt]
        UpdateUI()
      //  personalImageTxt.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "ProfileImage"))
        {
            let profileImage=UserDefaults.standard.value(forKey: "ProfileImage") as! String
            if let url=URL(string: profileImage){
                profileImageView.kf.setImage(with: url)
            }
        }
    }
    func UpdateUI(){
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "ProfileImage"))
        {
            let profileImage=UserDefaults.standard.value(forKey: "ProfileImage") as! String
            if let url=URL(string: profileImage){
                profileImageView.kf.setImage(with: url)
            }
        }
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "FullName"))
        {
            FullNametxt.text=(UserDefaults.standard.value(forKey: "FullName") as! String)
        }
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "Email"))
        {
            emailTxt.text=(UserDefaults.standard.value(forKey: "Email") as! String)
        }
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "Mobile"))
        {
            Mobiletxt.text=(UserDefaults.standard.value(forKey: "Mobile") as! String)
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        ChangePersonalImage()
        return false
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        if let data=personalImage.toBase64(){
            SendPersonalImage(data: data)
        }
        var isCompleted=true
        for (_,textField) in textFields.enumerated(){
            let (valid, message) = validate(textField)
            if(!valid){
                errorLbl.isHidden=false
                errorLbl.text=message
                isCompleted=false
                break
            }
        }
        if isCompleted{
            errorLbl.isHidden=true
            UpdateProfileData()
        }
    }
  
    func SendPersonalImage(data:String){
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "UserID"))
        {
            let userID=UserDefaults.standard.integer(forKey: "UserID")
            if let request = APIClient.ChangePersonalImage(userID: userID, fileName: "SAS.PNG", image: data){
                APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                    
                    if let  data = JsonValue{
                        let status=data["Status"]
                        if (status=="Success"){
                            print("successfuly change personal image")
                            // UserDefaults.standard.set(data["ImageLocation"],for:"ProfileImage")
                            if let ProfileImageURL=data["Data"]["ImageLocation"].string{
                            UserDefaults.standard.set(ProfileImageURL, forKey: "ProfileImage")
                            }
                        }
                    }
                    
                })
            }
        }
    }
    func UpdateProfileData(){
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "AccessToken")){
            let accessToken=UserDefaults.standard.value(forKey: "AccessToken") as! String
            if let request = APIClient.UpdateUserData(accessToken:accessToken,userName: emailTxt.text!, fullName: FullNametxt.text!, city: "", deviceToken: "abc", mobile: Mobiletxt.text!){
                APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                    
                    if let  data = JsonValue{
                        let status=data["Status"]
                        if (status=="Success"){
                            print("successfuly update profile data")
                            // UserDefaults.standard.set(data["ImageLocation"],for:"ProfileImage")
                            if let ProfileImageURL=data["Data"]["ImageLocation"].string{
                                UserDefaults.standard.set(ProfileImageURL, forKey: "ProfileImage")
                            }
                            if let mobile=data["Data"]["Mobile"].string{
                                UserDefaults.standard.set(mobile, forKey: "Mobile")
                            }
                            if let fullName=data["Data"]["FullName"].string{
                                UserDefaults.standard.set(fullName, forKey: "FullName")
                            }
                            if let email=data["Data"]["UserName"].string{
                                UserDefaults.standard.set(email, forKey: "Email")
                            }
                        }
                    }
                    
                })
            }
        }
    }
}
extension ProfilePersonalInfoVC:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func ChangePersonalImage()
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate=self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing=false
            present(imagePicker,animated: true, completion: nil)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage=info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profileImageView.image=pickedImage
            personalImage=pickedImage
            picker.dismiss(animated: true, completion: nil)
        }
     
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
       /* if textField == textFields[2] {
            return (text.count >= 6, "Your password is too short.")
        }*/
        if textField==textFields[2]{
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
