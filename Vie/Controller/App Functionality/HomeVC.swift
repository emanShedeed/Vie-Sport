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
