import Foundation
struct User {
    var email: String
    var password: String=""
    var fullName: String=""
    var mobile:String=""
    var operatingSystem="IOS"
    var socialType:String=""
    var socialUserID:String=""
    var deviceToken:String=""
    var imageLocation: String=""
    init(userEmail:String,userPassword:String,userFullName:String,userMobile:String,userOperatingSystem:String,userSocialType:String,userSocialUserID:String,UserDeviceToken:String,userImageLocation:String) {
        email=userEmail
        password=userPassword
        fullName=userFullName
        mobile=userMobile
        operatingSystem=userOperatingSystem
        socialType=userSocialType
        socialUserID=userSocialUserID
        deviceToken=UserDeviceToken
        imageLocation=userImageLocation
    }
}
