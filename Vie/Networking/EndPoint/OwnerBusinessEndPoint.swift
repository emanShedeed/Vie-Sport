import Alamofire
enum OwnerBusinessEndPoint :APIConfiguration {

    
    case SendConfirmationCode
    case ConfirmCode
    //MARK:- HTTPMethod
    var method:HTTPMethod{
        switch self {
        case .SendConfirmationCode ,.ConfirmCode:
            return .get
        }
    }
    //MArk: - Path
    var path:String{
        switch self {
        case .SendConfirmationCode:
            return "SendConfirmationCode"
        case.ConfirmCode:
            return "ConfirmCode"
        }
    }
    var parameters: Parameters?{
        switch self {
        case .SendConfirmationCode , .ConfirmCode:
            return nil
        }
    }

    // MARK: - URLRequestConvertible
    func getURL() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        let completePath = K.ProductionServer.OwnersBusiness + path
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
