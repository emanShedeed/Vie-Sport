//
//  HelperMethods.swift
//  Vie
//
//  Created by user137691 on 12/26/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
class HelperMethods
{
   static func IsKeyPresentInUserDefaults(key:String)->Bool{
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
