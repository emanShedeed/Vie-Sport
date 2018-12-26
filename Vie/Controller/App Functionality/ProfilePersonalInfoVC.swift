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
    
    var  imagePicker=UIImagePickerController()
    var personalImage=UIImage()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
       // self.tabBarController?.tabBar.isHidden=false
        // Do any additional setup after loading the view.
        //let tap=UITapGestureRecognizer(target: self, action: #selector(ChangePersonalImage))
        personalImageTxt.delegate=self
        
      //  personalImageTxt.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateUI()
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
            UpdateProfileData()
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
    
    
}
