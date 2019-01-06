//
//  AddingPlayGround_2VC.swift
//  Vie
//
//  Created by user137691 on 1/6/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit
import IQKeyboardManager

class AddingPlayGround_2VC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var playGoundInfoTextFields: [UITextField]!
    
    var playGroundObj=PlayGround()
    var textFieldTag=0
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
        for textField in playGoundInfoTextFields{
            textField.delegate=self
        }
        playGoundInfoTextFields.sort{$0.tag<$1.tag}
        pickerView.selectedRow(inComponent: 0)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textFieldTag = textField.tag
        if(textField.tag==1){
            pickerData=cityArray
        }
        else if(textField.tag==2){
            pickerData=districtArray
        }
        else if(textField.tag==3){
            pickerData=playGroundSizeArray
        }
        else if(textField.tag==4){
            pickerData=playGroundTypeArray
        }
        else if(textField.tag==5){
            pickerData=reservationTypeArray
        }
       
        //self.pickerView.reloadAllComponents()
        textField.text=pickerData[0]
        pickerView.delegate=self
        self.pickerView.isHidden=false
           
       // }
         return false
    }
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
        pickerView.isHidden=true
        playGoundInfoTextFields[textFieldTag-1].text=pickerData[row]
    }
 

}
