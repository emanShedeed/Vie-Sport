//
//  APIsRequests.swift
//  Vie
//
//  Created by user137691 on 10/17/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class APIsRequests{
    //MARK : - Alamofire Request Data
    func getStatus(from url:String,parameters:[String:String]){
        //var s:String?
        Alamofire.request(url,
                          method: .get,
                          parameters:parameters)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print( "Cann't get Status)")
                    return
                }
                 self.parseData(json: JSON( response.result.value!))
        }
    }
  
    func parseData(json :JSON){
        let Result = String(json[]["Status"].stringValue)
        let Messge=String(json[]["Message"].stringValue)
        NotificationCenter.default.post(name:.didCheckEmailStatus, object: self , userInfo: ["Status":Result,"Message":Messge] as [AnyHashable : Any])
        
    }
    func getData(from url:String,parameters:[String:String]){
        Alamofire.request(url,
                          method: .get,
                          parameters:parameters)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print( "Cann't get Data)")
                    return
                }
              //  SignUpVC().parseData(json: JSON( response.result.value!))
                NotificationCenter.default.post(name:.didReceiveJsonData , object: self , userInfo: ["JSON":JSON( response.result.value!)] as [AnyHashable : Any])
        }
    }}
