//
//  CalendarViewModel.swift
//  CalendarSwiftUI
//
//  Created by Julio Rico on 13/12/21.
//

import Foundation

extension CalendarView {
    final class ViewModel: ObservableObject {
        @Published var dates: [CalendarModel] = [CalendarModel]()
        @Published var firstDate: Date = Date()
        
        func loadData(showAccesories: Bool, selectedDate: Date, disablingDates: Bool) {
            dates.removeAll()
            dates = DateGlobalFunctions.initCalendar(from: firstDate, addAccesories: showAccesories, selectedDate: selectedDate, disablingDays: disablingDates)
        }
        
        func monthTitle() -> String {
            let lcoale = "EN-us"

            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: lcoale)
            formatter.dateFormat = "LLLL"
            
            return formatter.string(from: firstDate)
        }
        
        
        func yearValue() -> String {
            let (_, _, year) = DateGlobalFunctions.components(from: firstDate)
            
            return "\(year)"
        }
    }
}
