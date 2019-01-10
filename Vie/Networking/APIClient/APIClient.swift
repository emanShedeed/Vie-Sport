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
import SwiftyJSON
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
   
    
    //MARK: - Network Handler
    typealias requestCompletionHandler = (_ value: JSON?, _ statusCode: Int,_ responseMessageStatus:ResponseMessageStatusEnum?, _ userMessage:String?) -> (Void)
   // typealias errorHandler = (_ value: Any?, _ statusCode: Int, _ responseMessageStatus:ResponseMessageStatusEnum?, _ userMessage:String?) -> Void
 
    
    
    //MARK: - Request Function
    func jsonRequest(request: DataRequest,CompletionHandler: @escaping requestCompletionHandler) -> Void {
        
        request.responseJSON { response in
           
            let statusCode = response.response?.statusCode
            var value=JSON(response.value!)
            var responseMessageStatus:ResponseMessageStatusEnum!
            let userMessage = value[]["Message"].stringValue


            
            print("\n*****\nrequest url: \(String(describing: response.request?.url))\n*****")
            print("\n*****request JSON response: \n\(String(describing: response.result.value))\n*****")
            if response.result.isFailure {
                CompletionHandler(["error" : "Connection to server failed."], 500, nil, userMessage)
                return
            }
            
            if let status = value[]["Status"].string{
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
    static func AddUser(userObj:User)->DataRequest?{
        do{
            let request = Alamofire.request(try UserEndPoint.Add(userObj: userObj).getURL()).validate(statusCode:200..<501)
            return request
        }
        catch{}
        return nil
    }
    static func GetPlayGrounds(userID:Int,searchKey:String)->DataRequest?{
        do{
            var urlRequest = try playgroundEndPoint.get.getURL()
            var urlcomponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            urlcomponents?.queryItems=[URLQueryItem(name: "UserID", value:String(userID)),URLQueryItem(name: "SearchKey", value:searchKey)]
        urlRequest.url=urlcomponents?.url
            let request=Alamofire.request(urlRequest
                ).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
    }
    static func GetSimilarPlayGrounds(userID:String,PlayGroundID:String)->DataRequest?{
        do{
            var urlRequest = try playgroundEndPoint.GetSimilar.getURL()
            var urlcomponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            if userID != ""{
                urlcomponents?.queryItems=[URLQueryItem(name:"PlayGroundID", value: PlayGroundID),URLQueryItem(name: "UserID", value: userID)]
            }
            else{
                urlcomponents?.queryItems=[URLQueryItem(name:"PlayGroundID", value: PlayGroundID)]
            }
            
            urlRequest.url=urlcomponents?.url
            let request=Alamofire.request(urlRequest
                ).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
            
    }
    
    static func AddPlayGroundToFavorites(userID:Int,PlayGroundID:Int)->DataRequest?{
        do{
            let request=Alamofire.request(try FavoriteEndPoint.Add(userID: userID, playGroundID: PlayGroundID).getURL()).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
        
    }
    static func DeletePlayGroundFromFavorites(userID:Int,PlayGroundID:Int)->DataRequest?{
        do{
            let request=Alamofire.request(try FavoriteEndPoint.delete(userID: userID, playGroundID: PlayGroundID).getURL()).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
        
    }
    static func GetPeriods(AccessToken:String,PlayGroundID:String,Date:String)->DataRequest?{
        do{
            var urlRequest = try PeriodEndPoint.get.getURL()
            var urlcomponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            urlcomponents?.queryItems=[URLQueryItem(name:"PlayGroundID", value: PlayGroundID),URLQueryItem(name: "AccessToken", value: AccessToken),URLQueryItem(name: "Date", value: Date)]
            urlRequest.url=urlcomponents?.url
            let request=Alamofire.request(urlRequest
                ).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
        
    }
    static func AddReservation(AccessToken:String,PeriodID:Int)->DataRequest?{
        do{
            var urlRequest = try ReservationEndPoint.Add(periodID: PeriodID).getURL()
            var urlcomponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            
            urlcomponents?.queryItems=[URLQueryItem(name:"AccessToken", value: AccessToken)]
            urlRequest.url=urlcomponents?.url
            let request=Alamofire.request(urlRequest
                ).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
        
    }
    static func ChangePersonalImage(userID:Int,fileName:String,image:String)->DataRequest?{
        do{
            let request=Alamofire.request(try UserEndPoint.ChangeImage(userID:String(userID), fileName: fileName, image: image).getURL()).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
    }
    static func GetUserDetails(userID:Int,deviceToken:String)->DataRequest?{
        do{
            var urlRequest = try UserEndPoint.GetUsersDetails.getURL()
            var urlcomponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            urlcomponents?.queryItems=[URLQueryItem(name:"UserID", value: String(userID)),URLQueryItem(name: "DeviceToken", value: deviceToken)]
            urlRequest.url=urlcomponents?.url
            let request=Alamofire.request(urlRequest
                ).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
        
    }
    static func UpdateUserData(accessToken:String,userName:String,fullName:String,city:String,deviceToken:String,mobile:String)->DataRequest?{
        do{
            var urlRequest=try UserEndPoint.Update(userName: userName, fullName: fullName, city: city, operatingSystem: "IOS", deviceToken: deviceToken, mobile: mobile).getURL()
            var urlcomponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            urlcomponents?.queryItems=[URLQueryItem(name:"AccessToken", value: accessToken)]
            urlRequest.url=urlcomponents?.url
            let request=Alamofire.request(urlRequest).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
    }
    static func ChangePassword(userID:Int,oldPassword:String,newPassword:String)->DataRequest?{
        do{
            let request=Alamofire.request(try UserEndPoint.ChangePassword(userID: String(userID), oldPassword: oldPassword, newPassword: newPassword).getURL()).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
    }
    static func GetFavoritesPlayGrounds(accessToken:String)->DataRequest?{
        do{
            var urlRequest = try FavoriteEndPoint.getFavorites.getURL()
            var urlcomponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            urlcomponents?.queryItems=[URLQueryItem(name:"AccessToken", value: accessToken)]
            urlRequest.url=urlcomponents?.url
            let request=Alamofire.request(urlRequest
                ).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
        
    }
    static func GetReservations(accessToken:String)->DataRequest?{
        do{
            var urlRequest = try ReservationEndPoint.getReservations.getURL()
            var urlcomponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            urlcomponents?.queryItems=[URLQueryItem(name:"AccessToken", value: accessToken)]
            urlRequest.url=urlcomponents?.url
            let request=Alamofire.request(urlRequest
                ).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
    }
    static func CancelReservation(accessToken:String,reservaionID:Int)->DataRequest?{
        do{
            var urlRequest = try ReservationEndPoint.cancelReservation(reservationID: reservaionID).getURL()
            var urlcomponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            urlcomponents?.queryItems=[URLQueryItem(name:"AccessToken", value: accessToken)]
            urlRequest.url=urlcomponents?.url
            let request=Alamofire.request(urlRequest
                ).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
    }
    static func getDataForAddPlayGround(accessToken:String)->DataRequest?{
        do{
            var urlRequest = try SettingEndPoint.getForAddPlayGround.getURL()
            var urlcomponents=URLComponents(string: (urlRequest.url?.absoluteString)!)
            urlcomponents?.queryItems=[URLQueryItem(name:"AccessToken", value: accessToken)]
            urlRequest.url=urlcomponents?.url
            let request=Alamofire.request(urlRequest
                ).validate(statusCode: 200..<501)
            return request
        }
        catch{}
        return nil
    }
}
