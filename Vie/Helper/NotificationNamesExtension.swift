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
}
