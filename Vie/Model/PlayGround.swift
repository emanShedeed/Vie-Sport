//
//  PlayGround.swift
//  Vie
//
//  Created by user137691 on 11/11/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
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
    var Services:[PlaygrounServices]=[]
    var IsSupportsReservations: Bool=false
    var CashExtraFees:Int=0
    var Ml3byDiscountAmt:Int=0
    
    
    /*init( _Bio:String,_PlayGroundIDHashed:String,_ContactNumber:String,_ImagesLocation:[String], _OwnerMobile:String,_OwnerMobile2:String, _Lat:String, _Lng:String, _PlayGroundID:Int,  _PlayGroundName:String,_DimensionName:String,_CityName:String,_RatingLevel:Int,
          _PlayGroundTypeName:String,_IsFavorite:Bool,_Services:[PlaygrounServices],_IsSupportsReservations: Bool,_CashExtraFees:Int, _Ml3byDiscountAmt:Int=0) {
        Bio=_Bio
        PlayGroundIDHashed=_PlayGroundIDHashed
        ContactNumber=_ContactNumber
        ImagesLocation=_ImagesLocation
        OwnerMobile=_OwnerMobile
        OwnerMobile2=_OwnerMobile2
        Lat=_Lat
        Lng=_Lng
        PlayGroundID=_PlayGroundID
        PlayGroundName=_PlayGroundName
        DimensionName=_DimensionName
        CityName=_CityName
        RatingLevel=_RatingLevel
        PlayGroundTypeName=_PlayGroundTypeName
        IsFavorite=_IsFavorite
        Services=_Services
        IsSupportsReservations=_IsSupportsReservations
        CashExtraFees=_CashExtraFees
        Ml3byDiscountAmt=_Ml3byDiscountAmt
    }*/
}
struct PlaygrounServices{
    var ServiceID:Int=0
    var ServiceName:String=""
    var ActiveIcon:String=""
    /*init(_ServiceID:Int,_ServiceName:String,_ActiveIcon:String) {
        ServiceID=_ServiceID
        ServiceName=_ServiceName
        ActiveIcon=_ActiveIcon
    }*/
    
}
