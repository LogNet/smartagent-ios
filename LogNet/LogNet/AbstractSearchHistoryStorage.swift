//
//  File.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 8/20/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation

protocol AbstractSearchHistoryStorage {
    func addSearchHistoryItem(item:SearchHistoryItem, completion:ErrorCompletionBlock?)
    func fetchHistoryItems() -> [SearchHistoryItem]?
}