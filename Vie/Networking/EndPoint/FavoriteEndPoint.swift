//
//  FavoriteEndPoint.swift
//  Vie
//
//  Created by user137691 on 12/9/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
import Alamofire
enum FavoriteEndPoint:APIConfiguration{
    // case Add(email:String,password:String,fullName:String,mobile:String,socialType:String,socialUserID:String,deviceToken:String,imageLocation:String)
    case Add(userID:Int,playGroundID:Int)
    case delete(userID:Int,playGroundID:Int)
    case getFavorites
    // MARK: - HTTPMethod
    var method:HTTPMethod {
        switch self {
        case .Add:
            return .post
        case .delete:
            return .post
        case .getFavorites
            :
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .Add:
            return "Add"
        case .delete:
            return"Delete"
        case .getFavorites:
            return"Get"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .Add(let userID, let playgroundID) :
        return [K.APIParameterKey.userID:userID,K.APIParameterKey.playGroundID:playgroundID]
        case .delete(let userID, let playGroundID):
            return [K.APIParameterKey.userID:userID,K.APIParameterKey.playGroundID:playGroundID]
        case .getFavorites:
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func getURL() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        let completePath = K.ProductionServer.Favorites + path
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
