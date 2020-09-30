//
//  Date.swift
//  iChat
//
//  Created by Constantine Nikolsky on 29.09.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import Foundation

/// `?? self` isn't good idea, but I keep it for simplicity
extension Date {
    func change(_ component: Calendar.Component, _ value: Int) -> Date {
        Calendar.current.date(byAdding: component, value: value, to: self) ?? self
    }
    
    func toHoursAndMinutesString() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df.string(from: self)
    }
    
    func toDaysAndMonthsString() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd MMM"
        return df.string(from: self)
    }
    
    var midnight: Date {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? self
    }
    
    var isYesterdayOrEarlier: Bool {
        Date().midnight > self
     }
}
