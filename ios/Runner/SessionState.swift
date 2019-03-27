//
//  SessionState.swift
//  Runner
//
//  Created by Tomi Alagbe on 26/03/2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

/*
 *  Enum to handle the session of the user
 *  Different cases possible:
 *      - connect : The connection was succesfully or the user was already connected
 *      - disconnected : This value is set if the user was never login or he made a logout.
 */

enum SessionState {
    
    case connected
    case disconnected
    
}
