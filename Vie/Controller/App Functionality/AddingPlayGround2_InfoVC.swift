//
//  AddingPlayGround_2VC.swift
//  Vie
//
//  Created by user137691 on 1/6/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddingPlayGround2_InfoVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var playGroundInfoTextFields: [UITextField]!
    
    @IBOutlet var validationLabels: [UILabel]!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet var playGoundInfoTextFields: [UITextField]!
    @IBOutlet weak var customPickerView: UIView!
    @IBOutlet weak var pickerTitle: UILabel!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    
    @IBOutlet weak var inMaintainaceSegmentedControl: UISegmentedControl!
    
    var playGroundObj = PlayGround()
    var playGroundInfoDict = [String:Any]()
    var textFieldTag = 0
    var citiesDistrictsDict = [String:[(String,Int)]]()
    var cityArray=[String]()
   var districtArray:[(name:String,id:Int)] = [(String,Int)]()
    var dimensionsArray=[(String,Int)]()
    var playGroundTypeArray=[(String,Int)]()
    var reservationTypeArray:[(title:String,value:Int)] = [("ساعة",60),("ساعة ونصف",90),("ساعتين",120)]
    //name,checked,id
    var serviceArray=[(String,Bool,Int)]()
    typealias requestCompletionHandler =  (_ cityDistrictsDict:[String:[(String,Int)]],_ typeArray:[(String,Int)],_ sizeArray:[(String,Int)],_ serviceArray:[(String,Bool,Int)]) -> (Void)
    var pickerData:[String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="إضافة ملعب"
        // Do any additional setup after loading the view.
        playGoundInfoTextFields.sort{$0.tag<$1.tag}
        for textField in playGoundInfoTextFields{
            textField.delegate=self
        }
        upButton.isEnabled=false
        InitData { (dict, typeArray, sizeArray,services) -> (Void) in
            self.citiesDistrictsDict=dict
            self.cityArray=Array(dict.keys)
            self.playGroundTypeArray=typeArray
            self.dimensionsArray=sizeArray
            self.serviceArray=services
        }
    }
    func InitData(CompletionHandler: @escaping requestCompletionHandler){
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "AccessToken"))
        {
            var accessToken=UserDefaults.standard.value(forKey: "AccessToken") as! String
            accessToken="Guest"//temp
            if let request = APIClient.getDataForAddPlayGround(accessToken: accessToken){
                APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                    if let  data = JsonValue{
                        let status=data["Status"]
                        if (status=="Success"){
                            let cities = data["Data"]["Cities"]
                            var dict=[String:[(String,Int)]]()
                            for (_,cityObject) in cities{
                                var cityName=""
                                var districtName=""
                                var districtID:Int
                                var districts=[(String,Int)]()
                                cityName = cityObject["CityName"].stringValue
                                districts=[(String,Int)]()
                                let cityDistricts=cityObject["Districts"]
                                for(_,districtObject)in cityDistricts{
                                    districtName=districtObject["DistrictName"].stringValue
                                    districtID=districtObject["DistrictID"].intValue
                                    districts.append((districtName,districtID))
                                }
                                dict[cityName] = districts
                                
                            }
                            //get PlayGround Types
                            let types=data["Data"]["PlayGroundTypes"]
                            var typesArray=[(String,Int)]()
                            var typeName=""
                            var typeID:Int
                            for(_,playGroundTypeObj) in types{
                                typeName=playGroundTypeObj["PlayGroundTypeName"].stringValue
                                typeID=playGroundTypeObj["PlayGroundTypeID"].intValue
                                typesArray.append((typeName,typeID))
                            }
                            //get PlayGround Size
                            let dimensions=data["Data"]["Dimensions"]
                            var dimensionsArray=[(String,Int)]()
                            var dimensionName=""
                            var dismensionID:Int
                            for(_,playGroundSizeObj) in dimensions{
                                dimensionName=playGroundSizeObj["DimensionName"].stringValue
                                dismensionID=playGroundSizeObj["DimensionID"].intValue
                                
                                dimensionsArray.append((dimensionName,dismensionID))
                            }
                            let services=data["Data"]["ServicesList"]
                            var servicesArray=[(String,Bool,Int)]()
                            var serviceName=""
                            var serviceID:Int
                            for(_,serviceObject)in services{
                                serviceName = serviceObject["ServiceName"].stringValue
                                serviceID = serviceObject["ServiceID"].intValue
                                servicesArray.append((serviceName,false,serviceID))
                            }
                            CompletionHandler(dict,typesArray,dimensionsArray,servicesArray)
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
          playGoundInfoTextFields[1].text=""
            upButton.isEnabled=false
            downButton.isEnabled=true
        }
        else if(textField.tag==2){
            districtArray=citiesDistrictsDict[playGoundInfoTextFields[0].text ?? ""] ?? []
            pickerData=districtArray.map({$0.name})
            upButton.isEnabled=true
            downButton.isEnabled=true
        }
        else if(textField.tag==3){
            pickerData=dimensionsArray.map({$0.0})
            upButton.isEnabled=true
            downButton.isEnabled=true
        }
        else if(textField.tag==4){
            pickerData=playGroundTypeArray.map({$0.0})
            upButton.isEnabled=true
            downButton.isEnabled=true
        }
        else if(textField.tag==5){
            pickerData=reservationTypeArray.map{$0.title}
            upButton.isEnabled=true
            downButton.isEnabled=false
        }
       
        //self.pickerView.reloadAllComponents()
        if(textField.text != ""){
            if let index=pickerData?.firstIndex(of: textField.text!){
            pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            else{
            textField.text=""
            }
        }
        else{
            if (pickerData?.count)! > 0 {
                textField.text=pickerData?[0]
                pickerView.selectRow(0, inComponent: 0, animated: false)
                
            }
        }
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
    
    @IBAction func NextButtonPressed(_ sender: Any) {
        
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
            if let districtIndex=districtArray.firstIndex(where: {$0.name == playGoundInfoTextFields[1].text}){
                playGroundInfoDict["DistrictID"] = districtArray[districtIndex].1
            }else{
                playGroundInfoDict["DistrictID"] = nil
            }
            //
            if let dimensionIndex=dimensionsArray.firstIndex(where: {$0.0 == playGoundInfoTextFields[2].text}){
                playGroundInfoDict["DimensionID"] = dimensionsArray[dimensionIndex].1
            }else{
                playGroundInfoDict["DimensionID"] = nil
            }
            //
            if let typeIndex=playGroundTypeArray.firstIndex(where: {$0.0 == playGoundInfoTextFields[3].text}){
                playGroundInfoDict["PlayGroundTypeID"] = playGroundTypeArray[typeIndex].1
            }else{
                playGroundInfoDict["PlayGroundTypeID"] = nil
            }
            //
            if  let reservationIndex=reservationTypeArray.firstIndex(where: {$0.title == playGoundInfoTextFields[4].text}){
                playGroundInfoDict["ReservationTypeID"] = reservationTypeArray[reservationIndex].value
            }else{
                playGroundInfoDict["ReservationTypeID"] = nil
            }
            
            playGroundInfoDict["IsMaintance"] = inMaintainaceSegmentedControl.selectedSegmentIndex == 0 ? false : true
            performSegue(withIdentifier: "goToAddingPlayGround3_ServicesVC", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToAddingPlayGround3_ServicesVC"){
            let destinationVC = segue.destination as! AddingPlayGround3_ServicesVC
            destinationVC.playGroundInfoDict = playGroundInfoDict
            destinationVC.servicesArray=serviceArray
        }
    }
    // MARK: - Helper Methods
    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
        if textField==playGroundInfoTextFields[1]{
            districtArray=citiesDistrictsDict[playGoundInfoTextFields[0].text ?? ""] ?? []
            if districtArray.count>0{
                return (text.count > 0, "This field cannot be empty.")
            }else{
              
                return (true,"")
            }
        }
        else{
        return (text.count > 0, "This field cannot be empty.")
        }
    }
}
extension AddingPlayGround2_InfoVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData?[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        customPickerView.isHidden=true
        // pickerView.isHidden=true
        playGoundInfoTextFields[textFieldTag-1].text=pickerData?[row]
    }
    
    
}
