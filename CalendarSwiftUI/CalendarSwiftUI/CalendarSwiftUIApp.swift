//
//  CalendarSwiftUIApp.swift
//  CalendarSwiftUI
//
//  Created by Julio Rico on 13/12/21.
//

import SwiftUI

@main
struct CalendarSwiftUIApp: App {
    @State private var selectedDate = Date()
    var body: some Scene {
        WindowGroup {
            CalendarView(showAccesories: true, disablingAfterTodayDates: false, selectedDate: $selectedDate)
        }
    }
}
