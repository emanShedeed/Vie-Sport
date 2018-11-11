//
//  Home VC.swift
//  Vie
//
//  Created by user137691 on 11/11/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var collectionViewContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        collectionViewContainerView.isHidden=true
        mapContainerView.isHidden=false
        GetPlayGroundsData()
   
    }
    func GetPlayGroundsData(){
        if let  urlRequest=APIClient.GetPlayGrounds(){
            APIClient().jsonRequest(request: urlRequest) { (Json:Any?, statusCode:Int, ResponseMessageStatus:ResponseMessageStatusEnum?, userMessage:String?) -> (Void) in
                if let data=Json as? [String:Any]{
                    let status = data["Status"] as? String
                    let messge=data["Message"] as? String
                    print("get play grounds =\(status as Any)")
                    print(messge as Any)
                }
            }
        }
        
    }

    @IBAction func ToggleButtonPressed(_ sender: UIBarButtonItem) {
        if sender.tag==1{
            sender.tag=2
            collectionViewContainerView.isHidden=false
            mapContainerView.isHidden=true
        }
        else if sender.tag==2{
            sender.tag=1
            collectionViewContainerView.isHidden=true
            mapContainerView.isHidden=false
        }
        
    }
    
    
    
}
