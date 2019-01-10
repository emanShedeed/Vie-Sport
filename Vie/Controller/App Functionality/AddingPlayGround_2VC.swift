//
//  AddingPlayGround_2VC.swift
//  Vie
//
//  Created by user137691 on 1/6/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit
import IQKeyboardManager
import SwiftyJSON

class AddingPlayGround_2VC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var playGoundInfoTextFields: [UITextField]!
    @IBOutlet weak var customPickerView: UIView!
    @IBOutlet weak var pickerTitle: UILabel!
    
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    var playGroundObj=PlayGround()
    var textFieldTag=0
    var citiesDistrictsDict:[String:[String]]?
    var cityArray=["city1","city2","city3","city4","city5","city6","city7"]
    var districtArray=["district1","district2","district3","district4","district5","district6","district7"]
    var playGroundSizeArray=["playGroundSize1","playGroundSize2","item3","item4","item5","item6","item7"]
    var playGroundTypeArray=["playGroundType1","playGroundType2","item3","item4","item5","item6","item7"]
    var reservationTypeArray=["reservationType1","reservationType2","item3","item4","item5","item6","item7"]
    var pickerData=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="إضافة ملعب"
        // Do any additional setup after loading the view.
        playGoundInfoTextFields.sort{$0.tag<$1.tag}
        for textField in playGoundInfoTextFields{
            textField.delegate=self
        }
        upButton.isEnabled=false
        InitData()
    }
    func InitData(){
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "AccessToken"))
        {
            var accessToken=UserDefaults.standard.value(forKey: "AccessToken") as! String
            accessToken="Guest"//temp
            if let request = APIClient.getDataForAddPlayGround(accessToken: accessToken){
                APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                    
                    if let  data = JsonValue{
                        let status=data["Status"]
                        if (status=="Success"){
                            let cities = data["Cities"]
                            for (_,object) in cities{
                                }
                            
                            
                        }
                    }
                    
                })
            }
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textFieldTag = textField.tag
        if(textField.tag==1){
            pickerData=cityArray
            upButton.isEnabled=false
            downButton.isEnabled=true
        }
        else if(textField.tag==2){
            pickerData=districtArray
            upButton.isEnabled=true
            downButton.isEnabled=true
        }
        else if(textField.tag==3){
            pickerData=playGroundSizeArray
            upButton.isEnabled=true
            downButton.isEnabled=true
        }
        else if(textField.tag==4){
            pickerData=playGroundTypeArray
            upButton.isEnabled=true
            downButton.isEnabled=true
        }
        else if(textField.tag==5){
            pickerData=reservationTypeArray
            upButton.isEnabled=true
            downButton.isEnabled=false
        }
       
        //self.pickerView.reloadAllComponents()
        textField.text=pickerData[0]
        pickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView.delegate=self
        customPickerView.isHidden=false
        //self.pickerView.isHidden=false
           
       // }
         return false
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        customPickerView.isHidden=true
    }
    
    @IBAction func UpButtonPressed(_ sender: Any) {
        let index=textFieldTag-1
        let _ = textFieldShouldBeginEditing(playGoundInfoTextFields[index-1])
      
    }
    
    @IBAction func DownButtonPressed(_ sender: Any) {
        let index = textFieldTag-1
        let _ = textFieldShouldBeginEditing(playGoundInfoTextFields[index+1])
    }
}
extension AddingPlayGround_2VC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        customPickerView.isHidden=true
        // pickerView.isHidden=true
        playGoundInfoTextFields[textFieldTag-1].text=pickerData[row]
    }
    
 
    
}
