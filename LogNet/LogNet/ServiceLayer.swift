//
//  ServiceLayer.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/5/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

class ServiceLayer {
	lazy var serverServise: ServerService = {
		let service = SmartAgentServerServise()
		return service
	}()

    
}