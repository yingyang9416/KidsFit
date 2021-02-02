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
