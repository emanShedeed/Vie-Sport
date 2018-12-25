import Alamofire
enum UserEndPoint:APIConfiguration{
    
    
    case CheckEmail
    // case Add(email:String,password:String,fullName:String,mobile:String,socialType:String,socialUserID:String,deviceToken:String,imageLocation:String)
    case Add(userObj:User)
    case ChangeImage
   // case post(id: Int)
    
    // MARK: - HTTPMethod
    var method:HTTPMethod {
        switch self {
        case .CheckEmail:
            return .get
        case .Add,.ChangeImage:
            return .post
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .CheckEmail:
            return "CheckEmail"
        case .Add:
            return "Add"
        case .ChangeImage:
            return"ChangeImage"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .CheckEmail,.ChangeImage:
            return nil
        case .Add(let userObj):
            return [K.APIParameterKey.email:userObj.email,K.APIParameterKey.password:userObj.password,K.APIParameterKey.fullName:userObj.fullName,K.APIParameterKey.mobile:userObj.mobile,K.APIParameterKey.socialType:userObj.socialType,K.APIParameterKey.socialUserID:userObj.socialUserID,K.APIParameterKey.deviceToken:userObj.deviceToken,K.APIParameterKey.imageLocation:userObj.imageLocation,K.APIParameterKey.operatingSystem:userObj.operatingSystem]
        }
    }
    
    // MARK: - URLRequestConvertible
    func getURL() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        let completePath = K.ProductionServer.user + path
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
