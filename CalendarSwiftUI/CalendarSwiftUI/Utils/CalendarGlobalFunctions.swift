//
//  CalendarGlobalFunctions.swift
//  CalendarSwiftUI
//
//  Created by Julio Rico on 13/12/21.
//

import Foundation

struct DateGlobalFunctions {
    static func components(from date: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        return (
            components.day ?? 1,
            components.month ?? 1,
            components.year ?? 1990
        )
    }
    
    static func addValueTo(date: Date, component: Calendar.Component, value: Int) -> Date {
        guard let newDate = Calendar.current.date(byAdding: component, value: value, to: date) else {
            return Date()
        }
        return newDate
    }
    
    static func dayOfWeek(from date: Date) -> CustomDayOfWeeks {
        let calendar = Calendar(identifier: .gregorian)
        let dayOfWeek = calendar.dateComponents([.weekday], from: date)
        var customDayOfWeek: CustomDayOfWeeks = CustomDayOfWeeks.monday
        switch dayOfWeek.weekday {
        case 1:
            customDayOfWeek = .sunday
        case 2:
            customDayOfWeek = .monday
        case 3:
            customDayOfWeek = .tuesday
        case 4:
            customDayOfWeek = .wednesday
        case 5:
            customDayOfWeek = .thursday
        case 6:
            customDayOfWeek = .friday
        default:
            customDayOfWeek = .saturday
        }
        
        return customDayOfWeek
    }
    
    
    /// Initialize Calendar Data
    /// - Parameters:
    ///   - desiredDate: The date where the calendar starts to created its data.
    ///   - addAccesories: It helps to add special markers on the calendar (for example, a date with an event).
    ///   - selectedDate: When prsent, it marks a selected date with a different visual modidifer.
    ///   - disablingDays: When it sets to true, it disables the selection on dates further than the current date.
    /// - Returns: An array of `CalendarModel` to populate data on the UI.
    static func initCalendar(from desiredDate: Date, addAccesories: Bool, selectedDate: Date?, disablingDays: Bool = false) -> [CalendarModel] {
        // From date, build an array of dates for the first and last day of selected month.
        // First day starts on sunday(1) and last day ends on saturday (7).
        // Get first day of current month-date.
        
        var dates: [CalendarModel] = [CalendarModel]()
        let firstDayComponents = components(from: desiredDate.startOfMonth)
        let lastDayComponents = components(from: desiredDate.endOfMonth)
        var isToday: Bool = false
        var disabled: Bool = false
        let todayComponents = components(from: Date())
        var newDateComponents: (Int, Int, Int)
        
        for index in firstDayComponents.0...lastDayComponents.0 {
            let newDate = addValueTo(date: desiredDate.startOfMonth, component: .day, value: (index - 1))

            newDateComponents = components(from: newDate)
            
            isToday = (newDateComponents.0 == todayComponents.0 && newDateComponents.1 == todayComponents.1 && newDateComponents.2 == todayComponents.2)
            
            if disablingDays && (newDate > Date()) {
                disabled = true
            }
            
            let calendarElement = CalendarModel(isToday: isToday, isSelected: false, disabled: disabled, completeDate: newDate, accesories: [.inMonthRange])
            
            dates.append(calendarElement)
        }
        
        // Add dates from previous month, if the first's day of current month is not sunday.
        let dayOfWeekForFirstDay = dayOfWeek(from: desiredDate.startOfMonth)
        
        var insertIndex: Int = 0
        if dayOfWeekForFirstDay != .sunday {
            // If it is not sunday, then do nothing
            // otherwhise, if it is monday, add -1 to current day; if it is tuesday, add -2 day, and so on.
            for index in stride(from: dayOfWeekForFirstDay.rawValue, through: 1, by: -1) {
                let newDate = addValueTo(date: desiredDate.startOfMonth, component: .day, value: -index)

                let calendarElement = CalendarModel(isToday: false, isSelected: false, disabled: disablingDays, completeDate: newDate, accesories: [.outsideOfMonthRange])

                dates.insert(calendarElement, at: insertIndex)
                insertIndex += 1
            }
        }

        // Add dates from next month, if the last day of next month is not saturday
        let dayOfWeekForLastDay = dayOfWeek(from: desiredDate.endOfMonth)
        insertIndex = 1
        
        if dayOfWeekForLastDay != .saturday {
            for _ in dayOfWeekForLastDay.rawValue..<CustomDayOfWeeks.saturday.rawValue {
                let newDate = addValueTo(date: desiredDate.endOfMonth, component: .day, value: insertIndex)

                let calendarElement = CalendarModel(isToday: false, isSelected: false, disabled: disablingDays, completeDate: newDate, accesories: [.outsideOfMonthRange])

                dates.insert(calendarElement, at: dates.count)
                insertIndex += 1
            }
        }
        
        // If there is a selected date, then mark it
        if let selectedDate = selectedDate {
            let (day, month, year) = DateGlobalFunctions.components(from: selectedDate)
            
            dates.filter { $0.day == day && $0.month == month && $0.year == year }.first?.isSelected = true
        }
        
        return dates
    }

    static func initDaysOfWeekForCalendar() -> [DaysOfWeeksForCalendar] {
        let array: [DaysOfWeeksForCalendar] = [
            DaysOfWeeksForCalendar(day: "Sunday"),
            DaysOfWeeksForCalendar(day: "Monday"),
            DaysOfWeeksForCalendar(day: "Tuesday"),
            DaysOfWeeksForCalendar(day: "Wednesday"),
            DaysOfWeeksForCalendar(day: "Thursday"),
            DaysOfWeeksForCalendar(day: "Friday"),
            DaysOfWeeksForCalendar(day: "Saturday")
        ]
        
        return array
    }
    
    static func formatDateWithWeekDay(for date: Date) -> String {
        let dateFormatted: String
        let weekDay: String
        let lcoale = Locale.preferredLanguages.first ?? "es"

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: lcoale)

        formatter.dateFormat = "EEEE"
        weekDay = formatter.string(from: date)

        formatter.dateFormat = "MMM dd yyyy"
        
        dateFormatted = "\(weekDay), \(formatter.string(from: date))"
        
        return dateFormatted
    }
}
