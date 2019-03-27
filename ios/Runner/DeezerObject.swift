//
//  DeezerObject.swift
//  Runner
//
//  Created by Tomi Alagbe on 26/03/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

struct DeezerObject {
    
    let title: String
    let type: DeezerObjectType
    var object: DZRObject?
    
    init(title: String, type: DeezerObjectType, object: DZRObject? = nil) {
        self.title = title
        self.type = type
        self.object = object
    }
}
