//
//  ResultLogin.swift
//  Runner
//
//  Created by Tomi Alagbe on 26/03/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

enum ResultLogin {
    case success
    case logout
    case error(error: Error?)
}
