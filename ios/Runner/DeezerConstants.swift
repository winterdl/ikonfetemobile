//
//  DeezerConstants.swift
//  Runner
//
//  Created by Tomi Alagbe on 26/03/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

typealias DeezerObjectListRequest = (_ objectList: DZRObjectList? ,_ error: Error?) -> Void

struct DeezerConstant {
    
    // Key saved in Keychain
    struct KeyChain {
        static let deezerTokenKey = "DeezerTokenKey"
        static let deezerExpirationDateKey = "DeezerExpirationDateKey"
        static let deezerUserIdKey = "DeezerUserIdKey"
    }
    
    struct AppKey {
        //CHANGE THE VALUE WITH YOUR APP ID
        static let appId = "293124"
    }
    
}
