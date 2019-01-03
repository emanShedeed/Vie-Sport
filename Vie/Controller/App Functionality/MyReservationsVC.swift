//
//  ReservationVC.swift
//  Vie
//
//  Created by user137691 on 12/31/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
class MyReservationsVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var collextionView: UICollectionView!
    var currentReservations=[(PlayGround,Reservation)]()
    var oldReservations=[(PlayGround,Reservation)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Make header sticky
        if let layout=collextionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden=false
        if(HelperMethods.IsKeyPresentInUserDefaults(key: "AccessToken")){
            let accessToken=UserDefaults.standard.value(forKey: "AccessToken") as! String
            GetAllReservations(accessToken: accessToken) { (currentReservationArray, oldReservationsArray) in
                self.currentReservations = currentReservationArray
                self.oldReservations=oldReservationsArray
                self.collextionView.reloadData()
            }
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func GetAllReservations(accessToken:String,completion:@escaping (_ currecntReservationsarray:[(PlayGround,Reservation)],_ oldReservationsarray:[(PlayGround,Reservation)])->Void){
        var currecntReservationsarray:[(PlayGround,Reservation)]=[]
        var oldReservationsarray:[(PlayGround,Reservation)]=[]
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
                    for (_,Object) in data["Data"]["OldReservations"]{
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
                        oldReservationsarray.append((playGroundObj,reservationObj))
                    }
                    
                    completion(currecntReservationsarray,oldReservationsarray)
                   
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
            return currentReservations.count
        }
        else{
            return oldReservations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationCell", for: indexPath) as! ReservationCell
        var currentArray=[(PlayGround,Reservation)]()
        if(indexPath.section==0){
            currentArray=currentReservations
        }
        else{
            currentArray=oldReservations
        }
        let currentReservationObj=currentArray[indexPath.row]
        cell.playGroundName.text=currentReservationObj.0.PlayGroundName
        if(currentReservationObj.0.ImagesLocation.count>1)
        {
            if let url=URL(string: currentReservationObj.0.ImagesLocation[0]){
                cell.playGroundImage.kf.setImage(with: url)
            }
        }
        cell.date.text=currentReservationObj.1.Date
        cell.period.text=currentReservationObj.1.StartTime + " - " + currentReservationObj.1.EndTime
        
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! ReservationCellHeaderCollectionReusableView
        if(indexPath.section==0){
            sectionHeader.sectionHeaderLbl.text = "الحجوزات الحالية"
        }
        else{
            sectionHeader.sectionHeaderLbl.text = "الحجوزات السابقة"
        }
        return sectionHeader
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToMyReservationDetailsVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="goToMyReservationDetailsVC"){
            let destinationVC=segue.destination as! MyReservationDetailsVC
            let indexPath=collextionView.indexPathsForSelectedItems?.first
            if(indexPath?.section==0){
                
                destinationVC.playGroundReservationObj = currentReservations[indexPath!.row]
                destinationVC.isCurrenetReservation=true
            }
            else{
                destinationVC.playGroundReservationObj = oldReservations[indexPath!.row]
                destinationVC.isCurrenetReservation=false
            }
        }
    }
}
