//
//  ProfileVC.swift
//  Vie
//
//  Created by user137691 on 12/24/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON
class ProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var userEmailLbl: UILabel!
    
    var personalKeyWords=["المعلومات الشخصية","كلمة المرور","المفضلة"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.tableFooterView=UIView()
        tableView.isScrollEnabled=false
        self.navigationController?.navigationBar.isHidden=true
        GetProfileInfo()
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateUI()
    }
    func GetProfileInfo()
    {
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "UserID")){
            let userID=UserDefaults.standard.integer(forKey: "UserID")
            if let request = APIClient.GetUserDetails(userID: userID, deviceToken: "abc"){
                APIClient().jsonRequest(request: request, CompletionHandler: { (JsonValue: JSON?,statusCode:Int,responseMessageStatus:ResponseMessageStatusEnum?,userMessage:String?) -> (Void) in
                    
                    if let  data = JsonValue{
                        let status=data["Status"]
                        if (status=="Success"){
                            print("successfuly Get profile Data")
                            if let fullName=data["Data"]["FullName"].string{
                                UserDefaults.standard.set(fullName, forKey: "FullName")
                                self.userNameLbl.text=fullName
                            }
                            if let accessToken=data["Data"]["AccessToken"].string{
                                UserDefaults.standard.set(accessToken, forKey: "AccessToken")
                            }
                            if let imageLocation=data["Data"]["ImageLocation"].string{
                                UserDefaults.standard.set(imageLocation, forKey: "ProfileImage")
                                if let url=URL(string: imageLocation){
                                    self.profileImageView.kf.setImage(with: url)
                                }                            }
                            if let userName=data["Data"]["UserName"].string{
                                UserDefaults.standard.set(userName, forKey: "Email")
                                self.userEmailLbl.text=userName
                            }
                            if let mobile=data["Data"]["Mobile"].string{
                                UserDefaults.standard.set(mobile, forKey: "Mobile")
                            }
                        }
                    }
                    
                })
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
            userNameLbl.text=(UserDefaults.standard.value(forKey: "FullName") as! String)
        }
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "Email"))
        {
            userEmailLbl.text=(UserDefaults.standard.value(forKey: "Email") as! String)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalKeyWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.personalInfoLbl.text=personalKeyWords[indexPath.row]
        cell.indicatorLbl.text="<"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row==0){
            self.performSegue(withIdentifier: "goToProfilePersonalInfoVC", sender: self)
        }
    }
    
    
    
}
