//
//  PlayGroundServicesVC.swift
//  Vie
//
//  Created by user137691 on 11/25/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class PlayGroundServicesVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
 
    
    @IBOutlet weak var tableView: UITableView!
    var playGroundServices:[PlaygroundServices]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.tableFooterView=UIView()
        tableView.register(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        
       // configureTableView()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  playGroundServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        let serviceObj=playGroundServices[indexPath.row]
        cell.serviceName.text=serviceObj.ServiceName
        if let url=URL(string: serviceObj.ActiveIcon){
            if let data=try? Data(contentsOf: url){
                cell.serviceImageView.image=UIImage(data: data)
            }
        }
        return cell
    }
    func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight=120
       // messageTableView.separatorStyle = .none
    }
}
