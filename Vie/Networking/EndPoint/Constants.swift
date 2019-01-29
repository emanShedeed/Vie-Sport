import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = ""//Hidden for security
        static let user="users/"
        static let OwnersBusiness="OwnersBusiness/"
        static let PlayGround="PlayGrounds/"
        static let Period="Periods/"
        static let Reservation="Reservations/"
        static let Favorites="Favorites/"
        static let Setting="Settings/"
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
        static let periodID="PeriodID"
        static let userID="UserID"
        static let playGroundID="PlayGroundID"
        static let fileName="FileName"
        static let image="Image"
        static let userName="UserName"
        static let city="City"
        static let oldPassword="OldPassword"
        static let newPassword="NewPassword"
        static let reservationID="ReservationID"
        static let DistrictNameByGM="DistrictNameByGM"
        static let CityNameByGM="CityNameByGM"
        static let DistrictID="DistrictID"
        static let DimensionID="DimensionID"
        static let PlayGroundTypeID="PlayGroundTypeID"
        static let ReservationTypeID="ReservationTypeID"
        static let IsMaintance="IsMaintance"
        static let DraftPlayGroundServices="DraftPlayGroundServices"
        static let DraftPlayGroundDays="DraftPlayGroundDays"
        static let PlayGroundName="PlayGroundName"
        static let ResbonsibleName="ResbonsibleName"
        static let ContactNumber="ContactNumber"
        static let Price="Price"
        static let Remarks="Remarks"
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
