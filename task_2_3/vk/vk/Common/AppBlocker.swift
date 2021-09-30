//
//  PeriodicEventProvider.swift
//  vk
//
//  Created by Дмитрий Никишов on 01.10.2021.
//

import Foundation

class AppBlocker {
    public var handler : AppBlockerEvent?
    
    private var timer : Timer?
    
    private var timeBeforeBlockEvent : Int = 0
        
    public func start(appBlockTimeInSeconds : Int)
    {
        guard appBlockTimeInSeconds > 0 else {
            return
        }
        
        if nil == timer {
            timeBeforeBlockEvent = appBlockTimeInSeconds
            
            let timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(internalHandler),
                                         userInfo: nil,
                                         repeats: true)
            
            RunLoop.current.add(timer, forMode: .common)
            timer.tolerance = 0.1
            
            self.timer = timer
        }
    }
    
    public func stop()
    {
        if nil != timer {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc
    private func internalHandler()
    {
        self.handler?(self.timeBeforeBlockEvent)
        self.timeBeforeBlockEvent -= 1
    }
}
