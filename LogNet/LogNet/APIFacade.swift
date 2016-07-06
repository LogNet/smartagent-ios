//
//  APIFacade.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/6/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class APIFacade {
	private var service: ServerService

	init(service: ServerService) {
		self.service = service
	}

	func getRecentNotifications(fromID: Int?, chunkSize: Int8, completion: JSONCompletionBlock?) {
		self.service.getNotificationList(.Recent, subtype: "", from_id: nil, to_id: nil, from_time: nil, to_time: nil, chunks_size: nil, completion: completion)
	}
    
    func getRepriceNotifications(fromID: Int?, chunkSize: Int8, completion: JSONCompletionBlock?) {
        self.service.getNotificationList(.Reprice, subtype: "", from_id: nil, to_id: nil, from_time: nil, to_time: nil, chunks_size: nil, completion: completion)
    }
    
    func getCancelledNotifications(fromID: Int?, chunkSize: Int8, completion: JSONCompletionBlock?) {
        self.service.getNotificationList(.Cancelled, subtype: "", from_id: nil, to_id: nil, from_time: nil, to_time: nil, chunks_size: nil, completion: completion)
    }
    
    func getTickedDueNotifications(fromID: Int?, chunkSize: Int8, completion: JSONCompletionBlock?) {
        self.service.getNotificationList(.TicketDue, subtype: "", from_id: nil, to_id: nil, from_time: nil, to_time: nil, chunks_size: nil, completion: completion)
    }
}