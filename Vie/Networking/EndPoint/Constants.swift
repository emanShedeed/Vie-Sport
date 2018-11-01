import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "http://test100.revival.one/api/"
        static let user="users/"
        static let OwnersBusiness="OwnersBusiness/"
    }
    
    struct APIParameterKey {
        //static let password = "password"
        static let Email = "email"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
