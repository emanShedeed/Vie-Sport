//
//  ReservationEndPoint.swift
//  Vie
//
//  Created by user137691 on 12/19/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
import Alamofire
enum ReservationEndPoint:APIConfiguration{
    
    
  
    case Add(periodID:Int)
    case getReservations
    case cancelReservation(reservationID:Int)
    // MARK: - HTTPMethod
    var method:HTTPMethod {
        switch self {
        case .Add,.cancelReservation:
            return .post
        case .getReservations:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .Add:
            return "Add"
        case .getReservations:
            return "Get"
        case .cancelReservation:
            return "Cancel"
        }
        
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .Add(let periodID):
            return ["\(K.APIParameterKey.periodID)":periodID]
        case .getReservations:
            return nil
        case .cancelReservation(let reservationID):
            return [K.APIParameterKey.reservationID:reservationID]
        }
       
    }
    
    // MARK: - URLRequestConvertible
    func getURL() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        let completePath = K.ProductionServer.Reservation + path
        var urlRequest = URLRequest(url: url.appendingPathComponent(completePath))
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
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
    }}
