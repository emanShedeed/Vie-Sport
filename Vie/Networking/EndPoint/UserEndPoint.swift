import Alamofire
enum UserEndPoint:APIConfiguration{
    
    
    case CheckEmail
   // case posts
   // case post(id: Int)
    
    // MARK: - HTTPMethod
     var method:HTTPMethod {
        switch self {
  //      case .login:
  //          return .post
        case .CheckEmail:
            return .get
        }
    }
    
    // MARK: - Path
     var path: String {
        switch self {
       /* case .login:
            return "/login"
        case .posts:
            return "/posts"*/
        case .CheckEmail:
            return "CheckEmail"
        }
    }
    
    // MARK: - Parameters
     var parameters: Parameters? {
        switch self {
       /* case .login(let email, let password):
            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password]*/
        case .CheckEmail:
            return nil
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
