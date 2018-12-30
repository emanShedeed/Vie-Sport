import Alamofire
enum UserEndPoint:APIConfiguration{
    
    
    case CheckEmail
    // case Add(email:String,password:String,fullName:String,mobile:String,socialType:String,socialUserID:String,deviceToken:String,imageLocation:String)
    case Add(userObj:User)
    case ChangeImage(userID:String,fileName:String,image:String)
    case GetUsersDetails
    case ChangePassword(userID:String,oldPassword:String,newPassword:String)
    case Update(userName:String,fullName:String,city:String,operatingSystem:String,deviceToken:String,mobile:String)
   // case post(id: Int)
    
    // MARK: - HTTPMethod
    var method:HTTPMethod {
        switch self {
        case .CheckEmail,.GetUsersDetails:
            return .get
        case .Add,.ChangeImage,.Update,.ChangePassword:
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
        case .GetUsersDetails:
            return"GetUserDetails"
        case .Update:
            return"Update"
        case .ChangePassword:
            return"ChangePassword"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .CheckEmail,.GetUsersDetails:
            return nil
        case .Add(let userObj):
            return [K.APIParameterKey.email:userObj.email,K.APIParameterKey.password:userObj.password,K.APIParameterKey.fullName:userObj.fullName,K.APIParameterKey.mobile:userObj.mobile,K.APIParameterKey.socialType:userObj.socialType,K.APIParameterKey.socialUserID:userObj.socialUserID,K.APIParameterKey.deviceToken:userObj.deviceToken,K.APIParameterKey.imageLocation:userObj.imageLocation,K.APIParameterKey.operatingSystem:userObj.operatingSystem]
        case .ChangeImage(let userID, let fileName,let image):
            return [K.APIParameterKey.userID:userID,K.APIParameterKey.fileName:fileName,K.APIParameterKey.image:image]
        case .Update(let userName, let fullName,let city, let operatingSystem,let deviceToken, let mobile):
            return [K.APIParameterKey.userName:userName,K.APIParameterKey.fullName:fullName,K.APIParameterKey.city:city,K.APIParameterKey.operatingSystem:operatingSystem,K.APIParameterKey.deviceToken:deviceToken,K.APIParameterKey.mobile:mobile]
        case .ChangePassword(let userID,let oldPassword,let newPassword):
            return [K.APIParameterKey.userID:userID,K.APIParameterKey.oldPassword:oldPassword,K.APIParameterKey.newPassword:newPassword]
            
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
