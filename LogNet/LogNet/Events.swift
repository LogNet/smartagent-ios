//
//  Events.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 9/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class Events {
    
    // Actions
    static let ACTION_LOGIN = "action_login"
    static let ACTION_SHARE = "action_share"
    
    // Screens
    static let SCREEN_LOGIN = "screen_login"
    static let SCREEN_SEARCH = "screen_search"
    static let SCREEN_NOT_ACTIVATED = "screen_not_activated"
    static let SCREEN_RECENT_LIST = "screen_recent_list"
    static let SCREEN_REPRICE_LIST = "screen_reprice_list"
    static let SCREEN_CANCELLED_LIST = "screen_cancelled_list"
    static let SCREEN_TICKET_DUE_LIST = "screen_ticket_due_list"
    
    static let SCREEN_CANCELLED_PENDING_LIST = "screen_cancelled_pending_list"
    static let SCREEN_CANCELLED_COMPLETE_LIST = "screen_cancelled_complete_list"
    
    static let SCREEN_REPRICE_PENDING_LIST = "screen_reprice_pending_list"
    static let SCREEN_REPRICE_COMPLETE_LIST = "screen_reprice_complete_list"
    
    static let SCREEN_CANCELLED_DETAILS = "screen_cancelled_details"
    static let SCREEN_REPRICE_DETAILS = "screen_reprice_details"
    static let SCREEN_TICKET_DUE_DETAILS = "screen_ticket_due_details"
}