/*import Alamofire
import SwiftyJSON

class APIClient {
    static func CheckEmail(email: String,completion:@escaping (JSON)->Void) {
        Alamofire.request(UserEndPoint.CheckEmail(Email: email))
            .responseJSON { (response) in
                print("Result= \(response.result.value ?? "")")
                completion(JSON(response.result.value!))
        }
    }
}*/

//
//  NetworkManager.swift
//  Gafsha
//
//  Created by andrew on 3/5/17.
//  Copyright © 2017 Revival. All rights reserved.
//
import Foundation
import Alamofire

enum ResponseMessageStatusEnum:Int {
    case success = 1
    case failure = 2
    case exception = 3
}


/// NetworkManager is a class responsible for all server communications
class APIClient{
    //https://shaaer.app/
    #if RELEASE_VERSION
    private let baseUrl                                     :String =  "https://shaaer.app/api/"
    #else
    private let baseUrl                                     :String =  "https://shaaer.app/api/"//"http://sha3er2.revival.one/api/"//"http://sha3er.revival.one/api/"
    
    #endif
    private var afManager                                   :SessionManager!
    
    //MARK: - Network Handler
    typealias requestCompletionHandler = (_ value: Any?, _ statusCode: Int,_ responseMessageStatus:ResponseMessageStatusEnum?, _ userMessage:String?) -> (Void)
   // typealias errorHandler = (_ value: Any?, _ statusCode: Int, _ responseMessageStatus:ResponseMessageStatusEnum?, _ userMessage:String?) -> Void
    
    init()
    {
        
        self.afManager = Alamofire.SessionManager()
        
       // requestCompletionHandler = ({_,_,_  -> Void in})
        
       // errorHandler = ({_,_,_,_  -> Void in})
        
    }
    
    
    //MARK: - Request Function
    func jsonRequest(request: DataRequest,CompletionHandler:@escaping requestCompletionHandler) -> Void {
        
        request.responseJSON { response in
            
            let statusCode = response.response?.statusCode
            let value = response.result.value
            var responseMessageStatus:ResponseMessageStatusEnum!
            var userMessage:String!
            if let reponseJSON = value as? [String:Any] {
                if let message = reponseJSON["Message"] as? String {
                    userMessage = message
                }
            }
            
            print("\n*****\nrequest url: \(String(describing: response.request?.url))\n*****")
            print("\n*****request JSON response: \n\(String(describing: response.result.value))\n*****")
            if response.result.isFailure {
                CompletionHandler(["error" : "Connection to server failed."], 500, nil, userMessage)
                return
            }
            
            if let response = value as? [String:Any] {
                if let status = response["Status"] as? String {
                    
                    if status == "Success" {
                        responseMessageStatus = ResponseMessageStatusEnum.success
                    }
                    else if status == "Error" {
                        responseMessageStatus = ResponseMessageStatusEnum.failure
                    }
                    else if status == "Exception" {
                        responseMessageStatus = ResponseMessageStatusEnum.exception
                    }
                }
            }
            CompletionHandler(value, statusCode!, responseMessageStatus, userMessage)
            }
    }
    
    
    // MARK: - Network API Functions
  //  func register(_ signupData: [String:Any])
static func CheckEmail(email: String)->DataRequest? {
    
    do{
        var urlRequest = try UserEndPoint.CheckEmail.getURL()
        var urlComponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
        urlComponents!.queryItems=[URLQueryItem(name: "Email", value:email)]
        urlRequest.url=urlComponents?.url
        let request = Alamofire.request(urlRequest)
            .validate(statusCode: 200..<501)
        return request
    }
    catch{}
    return nil
    }
    static func SendConfirmationCode(mobile: String)->DataRequest? {
        
        do{
            var urlRequest = try OwnerBusinessEndPoint.SendConfirmationCode.getURL()
            var urlComponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            urlComponents!.queryItems=[URLQueryItem(name: "Mobile", value:mobile)]
            urlRequest.url=urlComponents?.url
            let request = Alamofire.request(urlRequest)
                .validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
    }
    static func Confirmcode(mobile:String,code:String)->DataRequest?{
        do{
            var urlRequest = try OwnerBusinessEndPoint.ConfirmCode.getURL()
            var urlcomponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            urlcomponents?.queryItems=[URLQueryItem(name:"Mobile", value: mobile),URLQueryItem(name: "Code", value: code)]
            urlRequest.url=urlcomponents?.url
            let request=Alamofire.request(urlRequest)
                .validate(statusCode:200..<501)
            return request
        }
        catch{}
        return nil
    }
}
