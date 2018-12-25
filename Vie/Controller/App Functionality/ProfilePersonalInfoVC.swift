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
    
    @IBOutlet weak var personalImageView: UIImageView!
    
    var  imagePicker=UIImagePickerController()
    var personalImage=UIImage()
   
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tabBarController?.tabBar.isHidden=false
        // Do any additional setup after loading the view.
        //let tap=UITapGestureRecognizer(target: self, action: #selector(ChangePersonalImage))
        personalImageTxt.delegate=self
        
      //  personalImageTxt.addGestureRecognizer(tap)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        ChangePersonalImage()
        return false
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        if let data=personalImage.toBase64(){
            SendPersonalImage(data: data)
        }
    }
    func IsKeyPresentInUserDefaults(key:String)->Bool{
        return UserDefaults.standard.object(forKey: key) != nil
    }
    func SendPersonalImage(data:String){
        if(IsKeyPresentInUserDefaults(key: "UserID"))
        {
            let userID=UserDefaults.standard.integer(forKey: "UserID")
            if let request = APIClient.ChangePersonalImage(userID: userID, fileName: "SAS.PNG", image: data){
                APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                    
                    if let  data = JsonValue{
                        let status=data["Status"]
                        if (status=="Success"){
                            print("successfuly change personal image")
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
   /* func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
        })
        
        personalImageView.image = image
    }*/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage=info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            personalImageView.image=pickedImage
            personalImage=pickedImage
           
           // let personalImageURL=[UIImagePickerController.InfoKey.imageURL]
           // dismiss(animated: true,completion: nil)
            picker.dismiss(animated: true, completion: nil)
        }
       /* if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            print(photoURL)
        }*/
    }
    
    
}
