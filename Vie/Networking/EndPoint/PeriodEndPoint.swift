//
//  PeriodEndPoint.swift
//  Vie
//
//  Created by user137691 on 12/10/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Alamofire
enum PeriodEndPoint:APIConfiguration{
    
    
    // case Add(email:String,password:String,fullName:String,mobile:String,socialType:String,socialUserID:String,deviceToken:String,imageLocation:String)
    case get
    // case post(id: Int)
    
    // MARK: - HTTPMethod
    var method:HTTPMethod {
        switch self {
        case .get:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .get:
            return "get"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .get:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func getURL() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        let completePath = K.ProductionServer.Period+path
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

