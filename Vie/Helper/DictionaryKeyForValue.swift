//
//  DictionaryKeyForValue.swift
//  Vie
//
//  Created by user137691 on 11/15/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import Foundation
extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
