//
//  UIImageExtension.swift
//  Vie
//
//  Created by user137691 on 12/25/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
import UIKit
extension UIImage{
    func toBase64()->String?{
        guard let imageData=self.pngData() else{return nil}
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
