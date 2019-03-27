//
//  ResultLoginData.swift
//  Runner
//
//  Created by Tomi Alagbe on 26/03/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

class ResultLoginData : NSObject {
    var userId: String
    var accessToken: String
    var expirationDate: Int
    
    init(userId: String, accessToken: String, expirationDate: Int) {
        self.userId = userId
        self.accessToken = accessToken
        self.expirationDate = expirationDate
    }
}
