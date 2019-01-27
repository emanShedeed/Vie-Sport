//
//  AppDelegate.swift
//  Vie
//
//  Created by user137691 on 10/9/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import GoogleMaps
import UserNotifications
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate,UNUserNotificationCenterDelegate ,MessagingDelegate{

    var window: UIWindow?
    //Mark status bar
    func setStatusBarBackGroundColor(color:UIColor){
        guard let statusBar=UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {return}
        statusBar.backgroundColor=color
    }
    // MARK :- Google Login
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //set status bar background
        setStatusBarBackGroundColor(color: UIColor.white)
        // Initialize  Google sign-in
        GIDSignIn.sharedInstance().clientID = "675308227558-mkip3tknssqppf3o825pjdq4r2ni9qol.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        //intialize FB Sign in
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        //intialize Google maps
        GMSServices.provideAPIKey("AIzaSyCri6mjXWVBDBBYTPnPsL9GUded9kUuWNI")
        
        
        // PNs
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            //implement user user notifucation center
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            //request user permission
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        //FCM generate  a token that needs to be sent to the server through didreceiveRegistrationToken method so we must be a delegate
        Messaging.messaging().delegate=self
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                //self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
        application.registerForRemoteNotifications()
        //////////////////
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            var profileImageURL:String?
            if user.profile.hasImage
            {
                let URL=user.profile.imageURL(withDimension: 100)
                profileImageURL=URL?.absoluteString ?? ""
            }
            let googleUserInfo = ["id": userId,"idToken": idToken, "name": fullName,"givenName":givenName,"familyName":familyName,"email":email,"picture":profileImageURL]
            
            //NotificationCenter.default.postNotification(name: .didReceiveData, object: self, userInfo: googleUserInfo)
            NotificationCenter.default.post(name: .didReceiveGoogleData, object: self, userInfo: googleUserInfo as [AnyHashable : Any])
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    //End of Google Login
    //MARK: - FB login
    func applicationDidBecomeActive(application: UIApplication!) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    //MARK : - End FB login
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //PN
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated
    }
    // map APN identifier to FCM generated key
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         Messaging.messaging().apnsToken = deviceToken
    }
    //
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        /*if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }*/
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
       /* if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }*/
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
}

