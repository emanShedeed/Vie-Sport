//
//  SocialSIgnUpVC.swift
//  Vie
//
//  Created by user137691 on 11/6/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class SocialSignUpVC: UIViewController {
    
    var socialData:[String:Any]?
    @IBOutlet var socialSinUpTextFields:[UITextField]!
    @IBOutlet var validationLabels:[UILabel]!
    override func viewDidLoad() {
        super.viewDidLoad()
        socialSinUpTextFields.sort{$0.tag<$1.tag}
        if let data=socialData{
        displayData(dict: data)
        }
        // Do any additional setup after loading the view.
    }
    
    func displayData(dict:[String:Any]){
            if let name=dict["name"] as? String{
            socialSinUpTextFields[0].text=name
        }
        if let email=dict["email"] as? String{
            socialSinUpTextFields[1].text=email
        }
        if let loginType=dict["loginType"]as? String{
            socialSinUpTextFields[3].text=loginType
        }
        
    }

}
