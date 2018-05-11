//
//  Date+Extensions.swift
//  Shopify-Winter-2018-Challenge
//
//  Created by Michael Ding on 2018-05-11.
//  Copyright © 2018 MDing. All rights reserved.
//

import Foundation

extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    
    // Gets year of the date
    func getYear() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}
