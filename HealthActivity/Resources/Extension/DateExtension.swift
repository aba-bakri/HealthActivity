//
//  DateExtension.swift
//  HealthActivity
//
//  Created by Ababakri Ibragimov on 16/11/22.
//

import Foundation

extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
    static let gregorian = Calendar(identifier: .gregorian)
}

extension Date {
    func byAdding(component: Calendar.Component, value: Int, wrappingComponents: Bool = false, using calendar: Calendar = .current) -> Date? {
        calendar.date(byAdding: component, value: value, to: self, wrappingComponents: wrappingComponents)
    }
    func dateComponents(_ components: Set<Calendar.Component>, using calendar: Calendar = .current) -> DateComponents {
        calendar.dateComponents(components, from: self)
    }
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        calendar.date(from: dateComponents([.yearForWeekOfYear, .weekOfYear], using: calendar))!
    }
    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    func daysOfWeek(using calendar: Calendar = .current) -> [Date] {
        let startOfWeek = self.startOfWeek(using: calendar).noon
        return (0...6).map { startOfWeek.byAdding(component: .day, value: $0, using: calendar)! }
    }
    
    func previousWeek(using calendar: Calendar = .current) -> [Date] {
        let dayOfWeek = calendar.component(.weekday, from: Date())
        let weekDays = calendar.range(of: .weekday, in: .weekOfYear, for: Date().addingTimeInterval(-60 * 60 * 24 * 7))!
        let dates = (weekDays.lowerBound ..< weekDays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: Date().addingTimeInterval(-60 * 60 * 24 * 7)) }
        return dates
    }
}

extension Formatter {
    static let ddd: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE"
        return dateFormatter
    }()
    
    static let test: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
}

extension Date {
    var ddd: String { Formatter.ddd.string(from: self) }
    var test: String { Formatter.test.string(from: self) }
}
