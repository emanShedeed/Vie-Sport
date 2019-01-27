//
//  AddingPlayGround3_ServicesVC.swift
//  Vie
//
//  Created by user137691 on 1/13/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import UIKit

class AddingPlayGround3_ServicesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var playGroundInfoDict=[String:Any]()
    var servicesArray:[(String,Bool,Int)]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.isScrollEnabled=false
        tableView.tableFooterView=UIView()
        tableView.register(UINib(nibName: "ServiceCell", bundle: nil)  , forCellReuseIdentifier: "ServiceCell")
    }
    //MARK:table view DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servicesArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        let serviceObj = servicesArray?[indexPath.row]
        cell.serviceName.text = serviceObj?.0
        cell.serviceImageView.isHidden=true
        if(serviceObj?.1 == true){
        cell.accessoryType = .checkmark
        }
        else
        {
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //let status = servicesArray?[indexPath.row].1 ?? false
        servicesArray?[indexPath.row].1 = true
       // tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        servicesArray?[indexPath.row].1 = false
    }
    

    @IBAction func NextButtonPressed(_ sender: Any) {
        var services=[[String:Int]]()///
        if let array=servicesArray{
        for(_,status,id)in array {
            if(status == true){
                services.append(["serviceID": id])
            }
            }
            playGroundInfoDict["DraftPlayGroundServices"]=services
            performSegue(withIdentifier: "goToAddingPlayGround4_WorkdaysVC", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToAddingPlayGround4_WorkdaysVC"){
            let destinationVC=segue.destination as! AddingPlayGround4_WorkdaysVC
            destinationVC.playGroundInfoDict=playGroundInfoDict
        }
    }
}
