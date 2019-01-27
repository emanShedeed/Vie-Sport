//
//  SettingsVC.swift
//  Vie
//
//  Created by user137691 on 1/3/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var SettingsKeyWords=["التنبيهات","إضافة ملعب","عن التطبيق","اتفاقية الاستخدام","شارك التطبيق","اتصل بنا"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView=UIView()
        tableView.isScrollEnabled=false
        self.tableView.rowHeight=50
        // Do any additional setup after loading the view.
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsKeyWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.personalInfoLbl.text=SettingsKeyWords[indexPath.row]
        if(indexPath.row==0){
            cell.switchButton.isHidden=false
            cell.indicatorLbl.isHidden=true
        }
        cell.indicatorLbl.text="<"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if(indexPath.row==1){
            self.performSegue(withIdentifier: "goToPlayGroundLocationVC", sender: self)
        }
        if(indexPath.row==2){
            self.performSegue(withIdentifier: "goToAboutVieVC", sender: self)
        }
        if(indexPath.row==3){
            self.performSegue(withIdentifier: "goToUsageAgreementVC", sender: self)
        }
        if(indexPath.row==4){
            let text = "This is the text...."
            let image = UIImage(named: "playground")
            // let myWebsite = NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")
            let shareAll = [text , image!] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            present(activityViewController, animated: true, completion: nil)
            
        }
        if(indexPath.row==5){
            let email = "info@vie-sport.com"
            let coded="mailto:\(email)?subject=تطبيق Vie".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let url = URL(string: coded!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}
