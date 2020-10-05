//
//  DateFormat.swift
//  reign
//
//  Created by Beto Salcido on 04/10/20.
//  Copyright © 2020 BetoSalcido. All rights reserved.
//

import Foundation
import UIKit

class DateFormat {
    static let shared = DateFormat()
    private init() {}
    
    func getDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = .init(identifier: "es_ES")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:date)!
        return date
    }

    func getPublicationDate(date: String) -> String {
        let diffComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: getDate(date: date), to: Date())
        let years = diffComponents.year
        let months = diffComponents.month
        let days = diffComponents.day
        let hours = diffComponents.hour
        let minutes = diffComponents.minute
        
        if let years = years, years > 0 {
            return "\(years) years"
        } else if let months = months, months > 0 {
            return "\(months) month"
        } else if let days = days, days > 0 {
            return "\(days) days"
        } else if let hours = hours, hours > 0  {
            if hours > 24 {
                return "Yesterday"
            } else {
                return "\(hours)hr"
            }
        } else if let minutes = minutes, minutes > 0 {
            return "\(minutes)m"
        } else {
            return ""
        }
    }
}
