//
//  AddingPlayGround4_WorkdaysVC.swift
//  Vie
//
//  Created by user137691 on 1/13/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit

class AddingPlayGround4_WorkdaysVC: UIViewController ,UITextFieldDelegate{
    var playGroundInfoDict=[String:[String]]()
    var hours=["1","2","3","4","5","6","7","8","9","10","11","12"]
    var minutes=["00","30"]
    var shift=["AM","PM"]
    var pickerData = [[String]]()
    var tableViewData=["السبت","الأحد","الأثنين","الثلاثاء","الأربعاء","الخميس","الجمعه"]
    var selectedTextfield:UITextField!
    @IBOutlet weak var startTimeTxt: UITextField!
    @IBOutlet weak var endTimeTxt: UITextField!
    
    @IBOutlet weak var customPickerView: UIView!
    
    @IBOutlet weak var datePickerView: UIPickerView!
    
    @IBOutlet weak var pickerTitle: UILabel!

    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pickerData=[hours,minutes,shift]
        startTimeTxt.delegate=self
        endTimeTxt.delegate=self
        startTimeTxt.setBottomBorder()
        endTimeTxt.setBottomBorder()
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
        datePickerView.delegate=self
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
        var hour=pickerData[0][0]
        var minute=pickerData[1][0]
        var shift=pickerData[2][0]
        if(component==0){
            hour = pickerData[component][pickerView.selectedRow(inComponent: component)]
        }else if (component == 1){
            minute = pickerData[component][pickerView.selectedRow(inComponent: component)]
            
        }else{
                shift = pickerData[component][pickerView.selectedRow(inComponent: component)]
            }
        selectedTextfield.text = hour + ":" + minute + " " + shift
    }
}
extension AddingPlayGround4_WorkdaysVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell") as! TimeCell
        cell.title.text=tableViewData[indexPath.row]
        return cell
      
    }
    
    
}
