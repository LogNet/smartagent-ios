//
//  APIFacade.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/6/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift

class APIFacade {
	private var service: ServerService

	init(service: ServerService) {
		self.service = service
	}

	func getRecentNotifications(fromID: Int?, chunkSize: Int8, completion: JSONCompletionBlock?)  {
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
    
    func register(phoneNumber: String, first_name: String,
                  last_name: String, email: String, uuid: String) -> Observable<String> {
        return self.service.register(phoneNumber, first_name: first_name, last_name: last_name, email: email, uuid: uuid)
    }
}