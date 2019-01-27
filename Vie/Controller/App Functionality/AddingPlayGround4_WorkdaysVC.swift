//
//  AddingPlayGround4_WorkdaysVC.swift
//  Vie
//
//  Created by user137691 on 1/13/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit

class AddingPlayGround4_WorkdaysVC: UIViewController ,UITextFieldDelegate{
    var playGroundInfoDict=[String:Any]()
    var hours=["1","2","3","4","5","6","7","8","9","10","11","12"]
    var minutes=["00","30"]
    var shift=["AM","PM"]
    var pickerData = [[String]]()
    //(isSelected,ID,dayName)
    var tableViewData=[(false,6,"السبت"),(false,0,"الأحد"),(false,1,"الأثنين"),(false,2,"الثلاثاء"),(false,3,"الأربعاء"),(false,4,"الخميس"),(false,5,"الجمعة")]
    var DraftPlayGroundDays = [[String:Int]]()
    var selectedTextfield:UITextField!
    var hour=""
    var minute=""
    var shiftValue=""
    @IBOutlet weak var startTimeTxt: UITextField!
    @IBOutlet weak var endTimeTxt: UITextField!
    
    @IBOutlet weak var customPickerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timePickerView: UIPickerView!
    
    @IBOutlet weak var pickerTitle: UILabel!

    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.tableFooterView=UIView()
        tableView.isScrollEnabled=false
        pickerData=[hours,minutes,shift]
        startTimeTxt.setBottomBorder(color: UIColor.darkGray)
        endTimeTxt.setBottomBorder(color: UIColor.darkGray)
        startTimeTxt.delegate=self
        endTimeTxt.delegate=self
        hour=pickerData[0][0]
        minute=pickerData[1][0]
        shiftValue=pickerData[2][0]
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        customPickerView.isHidden=false
        selectedTextfield=textField
        //textField.text=pickerData[0][0] + pickerData[1][0] + pickerData[2][0]
        if(textField==startTimeTxt){
            upButton.isEnabled=false
            downButton.isEnabled=true
            pickerTitle.text="وقت البداية"
        }else{
            upButton.isEnabled=true
            downButton.isEnabled=false
            pickerTitle.text="وقت النهاية"
        }
        if(textField.text != ""){
            var strings1=textField.text?.components(separatedBy: ":")
            var strings2=strings1![1].components(separatedBy: " ")
            let index1=pickerData[0].firstIndex(of: strings1![0])
            let index2=pickerData[1].firstIndex(of: strings2[0])
            let index3=pickerData[2].firstIndex(of: strings2[1])
            timePickerView.selectRow(index1!, inComponent: 0, animated: false)
            timePickerView.selectRow(index2!, inComponent: 1, animated: false)
            timePickerView.selectRow(index3!, inComponent: 2, animated: false)
        }
        else{
            timePickerView.selectRow(0, inComponent: 0, animated: false)
            timePickerView.selectRow(0, inComponent: 1, animated: false)
            timePickerView.selectRow(0, inComponent: 2, animated: false)
        }
        timePickerView.delegate=self
       
        customPickerView.isHidden=false
        return false
    }
    @IBAction func DoneButtonPressed(_ sender: Any) {
        customPickerView.isHidden=true
    }
    
    @IBAction func DownButtonPressed(_ sender: Any) {
       let _ = textFieldShouldBeginEditing(endTimeTxt)
    }
    
    @IBAction func upButtonPressed(_ sender: Any) {
        let _ = textFieldShouldBeginEditing(startTimeTxt)
    }
    
    @IBAction func NextButtonPressed(_ sender: Any) {
        for (selected,id,_) in tableViewData{
            if(selected){
                DraftPlayGroundDays.append(["DayID":id])
            }
        }
        playGroundInfoDict["DraftPlayGroundDays"] = DraftPlayGroundDays
        performSegue(withIdentifier: "goToAddingPlayGround5_InfoVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToAddingPlayGround5_InfoVC"){
            let destinationVC=segue.destination as! AddingPlayGround5_InfoVC
            destinationVC.playGroundInfoDict = playGroundInfoDict
        }
    }
}
extension AddingPlayGround4_WorkdaysVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return pickerData[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(component==0){
            hour = pickerData[component][pickerView.selectedRow(inComponent: component)]
        }else if (component == 1){
            minute = pickerData[component][pickerView.selectedRow(inComponent: component)]
            
        }else{
                shiftValue = pickerData[component][pickerView.selectedRow(inComponent: component)]
            }
        selectedTextfield.text = hour + ":" + minute + " " + shiftValue
    }
}
extension AddingPlayGround4_WorkdaysVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell") as! TimeCell
        cell.title.text=tableViewData[indexPath.row].2
        if(tableViewData[indexPath.row].0){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
      
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableViewData[indexPath.row].0=true
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        tableViewData[indexPath.row].0=false
    }
    
    
}
