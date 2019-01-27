//
//  PlaygroundEndPoint.swift
//  Vie
//
//  Created by user137691 on 11/11/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
import Alamofire
enum playgroundEndPoint:APIConfiguration{
    case get
    case GetSimilar
    case AddByApp(playGroundInfoDict:[String:Any])
    var method: HTTPMethod{
        switch self {
        case .get:
            return .get
        case .GetSimilar:
            return .get
        case .AddByApp:
            return .post
        }
    }
    
    var path: String{
        switch self {
        case .get:
            return "get"
        case .GetSimilar:
            return "GetSimilar"
        case .AddByApp:
            return"AddByApp"
        }
    }
    
    var parameters: Parameters?{
        switch self {
        case .get , .GetSimilar:
            return nil
        case .AddByApp(let dict):
            return [
                K.APIParameterKey.DistrictNameByGM:dict["DistrictNameByGM"] as Any,
                K.APIParameterKey.CityNameByGM:dict["CityNameByGM"] as Any,
                K.APIParameterKey.DistrictID:dict["DistrictID"] as Any,
                K.APIParameterKey.DimensionID:dict["DimensionID"]as Any,
                K.APIParameterKey.PlayGroundTypeID:dict["PlayGroundTypeID"] as Any,
                K.APIParameterKey.ReservationTypeID:dict["ReservationTypeID"] as Any,
                K.APIParameterKey.IsMaintance:dict["IsMaintance"] as Any,
                K.APIParameterKey.DraftPlayGroundServices:dict["DraftPlayGroundServices"] as Any,
                K.APIParameterKey.DraftPlayGroundDays:dict["DraftPlayGroundDays"] as Any,
                K.APIParameterKey.PlayGroundName:dict["PlayGroundName"] as Any,
                K.APIParameterKey.ResbonsibleName:dict["ResbonsibleName"] as Any,
                K.APIParameterKey.ContactNumber:dict["ContactNumber"] as Any,
                K.APIParameterKey.Price:dict["Price"] as Any,
                K.APIParameterKey.Remarks:dict["Remarks"] as Any
            ]
        }
    }
    
    func getURL() throws -> URLRequest {
        let url=try K.ProductionServer.baseURL.asURL()
        let completePath=K.ProductionServer.PlayGround+path
        var urlRequest=URLRequest(url: url.appendingPathComponent(completePath))
        urlRequest.httpMethod=method.rawValue
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
        
    }

}
