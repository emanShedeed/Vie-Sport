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
    var method: HTTPMethod{
        switch self {
        case .get:
            return .get
        case .GetSimilar:
            return .get
        }
    }
    
    var path: String{
        switch self {
        case .get:
            return "get"
        case .GetSimilar:
            return "GetSimilar"
        }
    }
    
    var parameters: Parameters?{
        switch self {
        case .get , .GetSimilar:
            return nil
      
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
