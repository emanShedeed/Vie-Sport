//
//  Home VC.swift
//  Vie
//
//  Created by user137691 on 11/11/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import SwiftyJSON
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
       var playGrounds:[PlayGround]=[]
        var playGroundObj:PlayGround=PlayGround()
        var serviceObj:PlaygrounServices=PlaygrounServices()
        if let  urlRequest=APIClient.GetPlayGrounds(){
            APIClient().jsonRequest(request: urlRequest) { (Json:JSON?, statusCode:Int, ResponseMessageStatus:ResponseMessageStatusEnum?, userMessage:String?) -> (Void) in
                if let data=Json {
                    //let status = data["Status"] as? String
                   // let messge=data["Message"] as? String
                    print("get play grounds")
                    //print(messge as Any)
                    //playGrounds=data[""] as? [PlayGround] ?? []
                 
                    for (_,object) in data{
                        playGroundObj=PlayGround()
                        playGroundObj.Bio = object["Bio"].stringValue
                        playGroundObj.PlayGroundIDHashed=object["PlayGroundIDHashed"].stringValue
                        playGroundObj.ContactNumber=object["ContactNumber"].stringValue
                        playGroundObj.ImagesLocation=object["ImagesLocation"].arrayObject as![String]
                        playGroundObj.OwnerMobile=object["OwnerMobile"].stringValue
                        playGroundObj.OwnerMobile2=object["OwnerMobile2"].stringValue
                        playGroundObj.Lat=object["Lat"].stringValue
                        playGroundObj.Lng=object["Lng"].stringValue
                        playGroundObj.PlayGroundID=object["PlayGroundID"].intValue
                        playGroundObj.PlayGroundName=object["PlayGroundName"].stringValue
                        playGroundObj.DimensionName=object["DimensionName"].stringValue
                        playGroundObj.CityName=object["CityName"].stringValue
                        playGroundObj.RatingLevel=object["RatingLevel"].intValue
                        playGroundObj.PlayGroundTypeName=object["PlayGroundTypeName"].stringValue
                        playGroundObj.IsFavorite=object["IsFavorite"].boolValue
                        for (_,service) in object["Services"]{
                            serviceObj=PlaygrounServices()
                            serviceObj.ServiceID=service["ServiceID"].intValue
                            serviceObj.ServiceName=service["ServiceName"].stringValue
                            serviceObj.ActiveIcon=service["ActiveIcon"].stringValue
                            playGroundObj.Services.append(serviceObj)
                        }
                        
                        playGroundObj.IsSupportsReservations=object["IsSupportReservations"].boolValue
                        playGroundObj.CashExtraFees=object["CashExtraFees"].intValue
                        playGroundObj.Ml3byDiscountAmt=object["Ml3byDiscountAmt"].intValue
                        playGrounds.append(playGroundObj)

                }
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
