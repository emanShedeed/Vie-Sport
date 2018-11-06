//
//  SocialSIgnUpVC.swift
//  Vie
//
//  Created by user137691 on 11/6/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class SocialSignUpVC: UIViewController {
    
    var socialData:[String:Any]?{
        didSet{
            
        }
    }
    @IBOutlet var socialSinUpTextFields:[UITextField]!
    @IBOutlet var validationLabels:[UILabel]!
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
