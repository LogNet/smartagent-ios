//
//  SearchHistoryContentProvider.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchContentProvider {
    var results:Variable<[AnyObject]?> = Variable(nil)
}