//
//  ReservationVC.swift
//  Vie
//
//  Created by user137691 on 12/31/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import SwiftyJSON
class ReservationVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    var currentReservation=[String]()
    var previousReservations=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    static func GetCurrentReservations(accessToken:String,completion:@escaping (_ currecntReservationsarray:[(PlayGround,Reservation)])->Void){
        var currecntReservationsarray:[(PlayGround,Reservation)]=[]
        var playGroundObj:PlayGround=PlayGround()
        var reservationObj:Reservation=Reservation()
        var serviceObj:PlaygroundServices=PlaygroundServices()
        
        if let  urlRequest=APIClient.GetReservations(accessToken: accessToken) {
            APIClient().jsonRequest(request: urlRequest) { (Json:JSON?, statusCode:Int, ResponseMessageStatus:ResponseMessageStatusEnum?, userMessage:String?) -> (Void) in
                if let data=Json {
                    for (_,Object) in data["Data"]["CurrentReservations"]{
                        playGroundObj=PlayGround()
                        let PlayGroundObject = Object["PlayGroundData"]
                        playGroundObj.Bio = PlayGroundObject["Bio"].stringValue
                        playGroundObj.PlayGroundIDHashed=PlayGroundObject["PlayGroundIDHashed"].stringValue
                        playGroundObj.ContactNumber=PlayGroundObject["ContactNumber"].stringValue
                        playGroundObj.ImagesLocation=PlayGroundObject["ImagesLocation"].arrayObject as![String]
                        playGroundObj.OwnerMobile=PlayGroundObject["OwnerMobile"].stringValue
                        playGroundObj.OwnerMobile2=PlayGroundObject["OwnerMobile2"].stringValue
                        playGroundObj.Lat=PlayGroundObject["Lat"].stringValue
                        playGroundObj.Lng=PlayGroundObject["Lng"].stringValue
                        playGroundObj.PlayGroundID=PlayGroundObject["PlayGroundID"].intValue
                        playGroundObj.PlayGroundName=PlayGroundObject["PlayGroundName"].stringValue
                        playGroundObj.DimensionName=PlayGroundObject["DimensionName"].stringValue
                        playGroundObj.CityName=PlayGroundObject["CityName"].stringValue
                        playGroundObj.RatingLevel=PlayGroundObject["RatingLevel"].intValue
                        playGroundObj.PlayGroundTypeName=PlayGroundObject["PlayGroundTypeName"].stringValue
                        playGroundObj.IsFavorite=PlayGroundObject["IsFavorite"].boolValue
                        for (_,service) in PlayGroundObject["Services"]{
                            serviceObj=PlaygroundServices()
                            serviceObj.ServiceID=service["ServiceID"].intValue
                            serviceObj.ServiceName=service["ServiceName"].stringValue
                            serviceObj.ActiveIcon=service["ActiveIcon"].stringValue
                            playGroundObj.Services.append(serviceObj)
                        }
                        playGroundObj.IsSupportsReservations=PlayGroundObject["IsSupportsReservations"].boolValue
                        playGroundObj.CashExtraFees=PlayGroundObject["CashExtraFees"].intValue
                        playGroundObj.Ml3byDiscountAmt=PlayGroundObject["Ml3byDiscountAmt"].intValue
                        //currecntReservationsarray.append(playGroundObj)
                        let reservationObject = Object["ReservationData"]
                        reservationObj=Reservation()
                        reservationObj.ReservationID=reservationObject["ReservationID"].intValue
                        reservationObj.Date=reservationObject["Date"].stringValue
                        reservationObj.StartTime=reservationObject["StartTime"].stringValue
                        reservationObj.EndTime=reservationObject["EndTime"].stringValue
                        reservationObj.Price=reservationObject["Price"].intValue
                        reservationObj.StatusID=reservationObject["StatusID"].intValue
                        reservationObj.Notes=reservationObject["Notes"].stringValue
                        reservationObj.Status=reservationObject["Status"].stringValue
                        currecntReservationsarray.append((playGroundObj,reservationObj))                    }
            
                        completion(currecntReservationsarray)
                    //self.DisplayPlayGroundData(playGrounds: self.playGrounds)
                    //self.performSegue(withIdentifier: "goToPlayGroundCollection", sender: self)
                }
            }
            
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section==0){
           return currentReservation.count
        }
        else{
            return previousReservations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
}
