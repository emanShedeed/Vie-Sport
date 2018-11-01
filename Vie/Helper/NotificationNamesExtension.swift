//
//  File.swift
//  Vie
//
//  Created by user137691 on 10/15/18.
//  Copyright © 2018 user137691. All rights reserved.
//
import NotificationCenter
extension Notification.Name {
    static let didReceiveGoogleData = Notification.Name("didReceiveGoogleData")
    static let didCheckEmailStatus = Notification.Name("didCheckEmailStatus")
    static let didSendConfirmationCode = Notification.Name("didSendConfirmationCode")
    static let didReceiveJsonData = Notification.Name("didReceiveJsonData")
  //  static let didReceiveJsonData2 = Notification.Name("didReceiveJsonData2")
}
extension NotificationCenter{
    func setObserver(_ observer: AnyObject, selector: Selector, name: NSNotification.Name, object: AnyObject?) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }
}
