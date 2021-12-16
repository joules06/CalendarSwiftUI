//
//  CalendarModels.swift
//  CalendarSwiftUI
//
//  Created by Julio Rico on 13/12/21.
//

import Foundation

class CalendarModel {
    let id: String = UUID().uuidString
    var isToday: Bool
    var isSelected: Bool
    var disabled: Bool
    
    let completeDate: Date
    var day: Int {
        DateGlobalFunctions.components(from: completeDate).0
    }
    var month: Int {
        DateGlobalFunctions.components(from: completeDate).1
    }
    var year: Int {
        DateGlobalFunctions.components(from: completeDate).2
    }
    var accesories: [CalendarAccesory] = []
    
    init(isToday: Bool, isSelected:Bool, disabled: Bool, completeDate: Date, accesories: [CalendarAccesory]) {
        self.isToday = isToday
        self.isSelected = isSelected
        self.disabled = disabled
        self.completeDate = completeDate
        self.accesories = accesories
    }
}

enum CalendarAccesory {
    case inMonthRange, outsideOfMonthRange
}

enum CustomDayOfWeeks: Int {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
}

struct DaysOfWeeksForCalendar: Hashable {
    let id: String = UUID().uuidString
    let day: String
    var firstLetter: String {
        String(day.prefix(1).uppercased())
    }
}
