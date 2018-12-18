//
//  PlayGround.swift
//  Vie
//
//  Created by user137691 on 11/11/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
import SwiftyJSON
import GoogleMaps
struct PlayGround{
    var Bio:String=""
    var PlayGroundIDHashed:String=""
    var ContactNumber:String=""
    var ImagesLocation:[String]=[]
    var OwnerMobile:String=""
    var OwnerMobile2:String=""
    var Lat:String=""
    var Lng:String=""
    var PlayGroundID:Int=0
    var PlayGroundName:String=""
    var DimensionName:String="5 * 5"
    var CityName:String=""
    var RatingLevel:Int=0
    var PlayGroundTypeName:String=""
    var IsFavorite:Bool=false
    var Services:[PlaygroundServices]=[]
    var IsSupportsReservations: Bool=false
    var CashExtraFees:Int=0
    var Ml3byDiscountAmt:Int=0
    
   static func GetPlayGroundsData(completion:@escaping (_ playGroundarray:[PlayGround])->Void){
        var playGrounds:[PlayGround]=[]
        var playGroundObj:PlayGround=PlayGround()
        var serviceObj:PlaygroundServices=PlaygroundServices()
        if let  urlRequest=APIClient.GetPlayGrounds(){
            APIClient().jsonRequest(request: urlRequest) { (Json:JSON?, statusCode:Int, ResponseMessageStatus:ResponseMessageStatusEnum?, userMessage:String?) -> (Void) in
                if let data=Json {
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
                            serviceObj=PlaygroundServices()
                            serviceObj.ServiceID=service["ServiceID"].intValue
                            serviceObj.ServiceName=service["ServiceName"].stringValue
                            serviceObj.ActiveIcon=service["ActiveIcon"].stringValue
                            playGroundObj.Services.append(serviceObj)
                        }
                        playGroundObj.IsSupportsReservations=object["IsSupportsReservations"].boolValue
                        playGroundObj.CashExtraFees=object["CashExtraFees"].intValue
                        playGroundObj.Ml3byDiscountAmt=object["Ml3byDiscountAmt"].intValue
                        playGrounds.append(playGroundObj)
                    }
                    completion(playGrounds)
                    //self.DisplayPlayGroundData(playGrounds: self.playGrounds)
                    //self.performSegue(withIdentifier: "goToPlayGroundCollection", sender: self)
                }
            }
            
        }
    }
    //Mark : - GetSimilarPlayGrounds
    static func GetSimilarPlayGroundsData(playGroundID:String,userID:String,completion:@escaping (_ similarPlayGroundarray:[PlayGround])->Void){
        var similarPlayGrounds:[PlayGround]=[]
        var playGroundObj:PlayGround=PlayGround()
        var serviceObj:PlaygroundServices=PlaygroundServices()
        if let  urlRequest=APIClient.GetSimilarPlayGrounds(userID: userID, PlayGroundID: playGroundID){
            APIClient().jsonRequest(request: urlRequest) { (Json:JSON?, statusCode:Int, ResponseMessageStatus:ResponseMessageStatusEnum?, userMessage:String?) -> (Void) in
                if let data=Json {
                    for (_,object) in data["Data"]{
                        playGroundObj=PlayGround()
                        playGroundObj.Bio = object["Bio"].stringValue
                        playGroundObj.PlayGroundIDHashed=object["PlayGroundIDHashed"].stringValue
                        playGroundObj.ContactNumber=object["ContactNumber"].stringValue
                        playGroundObj.ImagesLocation=object["ImagesLocation"].arrayObject as?[String] ?? []
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
                            serviceObj=PlaygroundServices()
                            serviceObj.ServiceID=service["ServiceID"].intValue
                            serviceObj.ServiceName=service["ServiceName"].stringValue
                            serviceObj.ActiveIcon=service["ActiveIcon"].stringValue
                            playGroundObj.Services.append(serviceObj)
                        }
                        playGroundObj.IsSupportsReservations=object["IsSupportsReservations"].boolValue
                        playGroundObj.CashExtraFees=object["CashExtraFees"].intValue
                        playGroundObj.Ml3byDiscountAmt=object["Ml3byDiscountAmt"].intValue
                        similarPlayGrounds.append(playGroundObj)
                    }
                    completion(similarPlayGrounds)
                 
                }
            }
            
        }
    }
    //have tow uses
    //1-check array of play grounds to get nerest to user location
    //2-we can send the array as only one object to get the disatance from usser location
    static func GetDistance(playGrounds: [PlayGround], userLocation: CLLocation) -> CLLocationDistance? {
        if playGrounds.count == 0 {
            return nil
        }
        
        // var closestLocation: CLLocation?
        var smallestDistance: CLLocationDistance?
        var playGroundLocation : CLLocation
        for obj in playGrounds {
            playGroundLocation=CLLocation(latitude: Double(obj.Lat)!,longitude: Double(obj.Lng)!)
            let distance = playGroundLocation.distance(from: userLocation)
            if smallestDistance == nil || distance < smallestDistance ?? 0.0{
                //      closestLocation = playGroundLocation
                smallestDistance = distance
            }
        }
        
        // print("closestLocation: \(String(describing: closestLocation)), distance: \(String(describing: smallestDistance))")
        return smallestDistance
    }
}

struct PlaygroundServices{
    var ServiceID:Int=0
    var ServiceName:String=""
    var ActiveIcon:String=""
    /*init(_ServiceID:Int,_ServiceName:String,_ActiveIcon:String) {
        ServiceID=_ServiceID
        ServiceName=_ServiceName
        ActiveIcon=_ActiveIcon
     }*/
}
