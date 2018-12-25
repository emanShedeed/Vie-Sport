//
//  ProfileVC.swift
//  Vie
//
//  Created by user137691 on 12/24/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!
    var personalKeyWords=["المعلومات الشخصية","كلمة المرور","المفضلة"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView=UIView()
        tableView.isScrollEnabled=false
        self.navigationController?.navigationBar.isHidden=true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     */
    
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
