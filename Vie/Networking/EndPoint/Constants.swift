import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "http://test100.revival.one/api/"
        static let user="users/"
        static let OwnersBusiness="OwnersBusiness/"
        static let PlayGround="PlayGrounds/"
        static let Period="Periods/"
    }
    
    struct APIParameterKey {
        static let email="UserName"
        static let password="Password"
        static let fullName="FullName"
        static let mobile="Mobile"
        static let operatingSystem="OS"
        static let socialType="SocialType"
        static let socialUserID="SocialUserID"
        static let imageLocation="ImageLocation"
        static let deviceToken="DeviceToken"
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
