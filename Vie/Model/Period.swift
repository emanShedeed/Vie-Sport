//
//  Period.swift
//  Vie
//
//  Created by user137691 on 12/10/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
import SwiftyJSON
struct Period {
    var CashExtraFees: Int=0
    var EndTime: String=""
    var IsReserved: Bool=false
    var Ml3byPrice:Int=0
    var PeriodID:Int=0
    var Price:Int=0
    var StartTime:String=""
    //Mark : - GetSimilarPlayGrounds
    static func GetPeriods(date:String,PlayGroundIDHashed:String,completion:@escaping (_ periodsarray:[Period])->Void){
        var periods:[Period]=[]
        var periodObj:Period=Period()
        if let  urlRequest=APIClient.GetPeriods(AccessToken: UserDefaults.standard.string(forKey: "AccessToken")!, PlayGroundID: PlayGroundIDHashed, Date: date){
            APIClient().jsonRequest(request: urlRequest) { (Json:JSON?, statusCode:Int, ResponseMessageStatus:ResponseMessageStatusEnum?, userMessage:String?) -> (Void) in
                if let data=Json {
                    let status=data["Status"]
                    if (status=="Success"){
                        let periodsData=data["Data"].arrayObject
                        if((periodsData?.count)!>0){
                            for (_,object) in data["Data"]{
                                periodObj=Period()
                                periodObj.CashExtraFees = object["CashExtraFees"].intValue
                                
                                periodObj.EndTime=object["EndTime"].stringValue
                                periodObj.IsReserved=object["IsReserved"].boolValue
                                periodObj.Ml3byPrice=object["Ml3byPrice"].intValue
                                periodObj.PeriodID=object["PeriodID"].intValue
                                periodObj.Price=object["Price"].intValue
                                periodObj.StartTime=object["StartTime"].stringValue
                                periods.append(periodObj)
                            }
                        }
                        completion(periods)
                        
                    }
                }
                
            }
        }
    }
    
}
