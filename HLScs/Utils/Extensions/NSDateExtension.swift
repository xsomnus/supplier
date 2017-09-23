//
//  NSDateExtension.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/15.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import Foundation

extension NSDate {
    class func getToday() ->String? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
       
        return dateString
    }
    
    class func getPreviousDay() -> String? {
        let date = Date(timeInterval: -24*60*60, since: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
        
    }
    
    class func getAWeekAgo() -> String? {
        let date = Date(timeInterval: -7*24*60*60, since: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    class func getNextDay() -> String? {
        let date = Date(timeInterval: 24*60*60, since: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
}

extension Date {
    
    func toString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}








