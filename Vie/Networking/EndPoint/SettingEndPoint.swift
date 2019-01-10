//
//  Settings.swift
//  Vie
//
//  Created by user137691 on 1/10/19.
//  Copyright © 2019 user137691. All rights reserved.
//

import Alamofire
enum SettingEndPoint:APIConfiguration{
    
    
    case getForAddPlayGround
    
    // MARK: - HTTPMethod
    var method:HTTPMethod {
        switch self {
        case .getForAddPlayGround:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .getForAddPlayGround:
            return "GetForAddPlayGround"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .getForAddPlayGround:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func getURL() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        let completePath = K.ProductionServer.Setting + path
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

