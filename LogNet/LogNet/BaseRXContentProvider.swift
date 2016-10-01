//
//  BaseRXContentProvider.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/26/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseRXContentProvider {
    let results:Variable<[Any]?> = Variable(nil)
}