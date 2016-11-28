//
//  EnvironmentSetter.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 11/28/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import Foundation
import RxSwift

let DEFAULT_URL_KEY = "DEFAULT_URL_KEY"

class EnvironmentSetter {
    
    class func getDefaultURL() -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let url = defaults.stringForKey(DEFAULT_URL_KEY) {
            return url
        }
        return "https://www.lognet-smartagent.com/"
    }
    
    class func setDefaultURL(url:String?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(url, forKey: DEFAULT_URL_KEY)
    }
    
    let openHostSettings = Variable(false)
    private var timer: NSTimer!
    private var seconds = 0
    private var taps = 0
    private let maxTapsCount:Int
    
    init(maxTapsCount:Int){
        self.maxTapsCount = maxTapsCount
    }
    
    // MARK: Public
    
    func tap() {
        self.seconds = 0
        self.taps += 1
        guard self.taps < maxTapsCount else {
            self.openHostSettings.value = true
            self.taps = 0
            return
        }
        
        if self.timer == nil {
            if self.openHostSettings.value == true {
                self.openHostSettings.value = false
            }
            self.startTimer()
        }
    }
    
    // MARK: Private
    
    private func startTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc private func update() {
        self.seconds += 1
        if self.seconds > 1 {
            self.seconds = 0
            self.timer.invalidate()
            self.timer = nil
            self.taps = 0
            print(self.seconds)
        }
    }
    
    deinit {
        self.timer.invalidate()
        self.timer = nil
    }
    
}