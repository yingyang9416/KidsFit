//
//  DateFormatterExtension.swift
//  KidsFit
//
//  Created by Steven Yang on 1/31/21.
//

import Foundation

enum DateTimeFormat: String {
    case longReadableMonthAndYear = "MMMM YYYY"
    case longReadableDateFormat = "MMMM dd yyyy"
    case shortReadableDateFormat = "MMM dd, yyyy"
    case readableMonthAndDate = "MMM dd"
    case readableMonth = "MMM"
    case readableDate = "dd"
    case dateFormat = "dd-MMM-yyyy"
    case fromJson = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
    case fromJsonDateOnly = "yyyy-MM-dd"
    case shortWeekMonthDay = "EEE, MMM dd"
    case timeFormat = "hh:mm a"
    case quarter = "Q"
    case combinedDateTime = "dd-MMM-yyyy - hh:mm a"
    case fromJsonNoTimeZone = "yyyy-MM-dd'T'HH:mm:ss.sss"
    
    case dateIdFormat = "YYYYMMdd"

}

extension DateFormatter {
    func dateString(from date: Date, format: DateTimeFormat) -> String {
        self.dateFormat = format.rawValue
        return self.string(from: date)
    }
    
    func date(from string: String?, format: DateTimeFormat) -> Date? {
        if let string = string {
            self.dateFormat = format.rawValue
            return self.date(from: string)
        } else {
            return nil
        }
    }
    
    func timeString(from date: Date, format: DateTimeFormat = .timeFormat) -> String {
        self.dateFormat = format.rawValue
        return self.string(from: date)
    }
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func isInSameYear(with date: Date) -> Bool {
        return Calendar.current.component(.year, from: self) == Calendar.current.component(.year, from: date)
    }
    
    func isInSameMonth(with date: Date) -> Bool {
        return isInSameYear(with: date) && Calendar.current.component(.month, from: self) == Calendar.current.component(.month, from: date)
    }
    
    func isOnSameDay(with date: Date) -> Bool {
        return isInSameMonth(with: date) && Calendar.current.component(.day, from: self) == Calendar.current.component(.day, from: date)
    }
    
    
    func displayableTimePast(toDate: Date) -> String {
        let delta = Int(toDate - self)
        guard delta > 0 else { return "" }
        
        if delta < 60 {
            return "\(delta) seconds ago"
        } else if delta < (60 * 60) {
            let minutes = delta / 60
            return "\(minutes) \(minutes == 1 ? "minute" : "minutes") ago"
        } else if delta < (60 * 60 * 24) {
            let hours = delta / (60 * 60)
            return "\(hours) \(hours == 1 ? "hour" : "hours") ago"
        } else if delta < (60 * 60 * 24 * 7) {
            let days = delta / (60 * 60 * 24)
            return "\(days) \(days == 1 ? "day" : "days") ago"
        } else if isInSameYear(with: toDate) {
            return DateFormatter().dateString(from: self, format: .readableMonthAndDate)
        } else {
            return DateFormatter().dateString(from: self, format: .shortReadableDateFormat)
        }
        
    }
    
    func dispayableWodDate() -> String {
        if Calendar.current.isDateInToday(self) {
            return "Today"
        } else if Calendar.current.isDateInTomorrow(self) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        } else if self.isInSameYear(with: Date()) {
            return DateFormatter().dateString(from: self, format: .shortWeekMonthDay)
        } else {
            return DateFormatter().dateString(from: self, format: .shortReadableDateFormat)
        }
    }
}
