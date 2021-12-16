//
//  ContentView.swift
//  CalendarSwiftUI
//
//  Created by Julio Rico on 13/12/21.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = ViewModel()
    @Binding var selectedDate: Date
    
    let daysOfWeek = DateGlobalFunctions.initDaysOfWeekForCalendar()
    var items: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 80)), count: 7)
    }
    
    var showAccesories: Bool
    var disablingAfterTodayDates: Bool
    
    init(showAccesories: Bool, disablingAfterTodayDates: Bool, selectedDate: Binding<Date>) {
        self.showAccesories = showAccesories
        self.disablingAfterTodayDates = disablingAfterTodayDates
        _selectedDate = selectedDate
        
    }
    var body: some View {
        ZStack {
            Color.blackAlmost
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            add(value: -1, using: .month)
                        }
                    }) {
                        Image(systemName: "arrow.left.circle")
                            .padding()
                            .foregroundColor(.blueWhite)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.monthTitle())
                        Text(viewModel.yearValue())
                            .font(.title)
                    }
                    .foregroundColor(.blueWhite)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            add(value: 1, using: .month)
                        }
                    }) {
                        Image(systemName: "arrow.forward.circle")
                            .padding()
                            .foregroundColor(.blueWhite)
                    }
                }
                .padding(.top, 30)
                VStack {
                    LazyVGrid(columns: items, spacing: 10) {
                        ForEach(daysOfWeek, id: \.id) { day in
                            Text(day.firstLetter)
                                .foregroundColor(.blueWhite)
                                .padding()
                        }
                    }
                    LazyVGrid(columns: items, spacing: 10) {
                        ForEach(viewModel.dates, id: \.id) { date in
                            Button(action: {
                                selectedDate = date.completeDate
                                viewModel.loadData(showAccesories: showAccesories, selectedDate: selectedDate, disablingDates: disablingAfterTodayDates)
                            }) {
                                Text("\(date.day)")
                                    .font(.caption)
                                    .padding(5)
                                    .foregroundColor(date.accesories.contains(.inMonthRange) ? .black : .black.opacity(0.4))
                                    .if(date.isSelected) {
                                        $0.background(Color.black.opacity(0.6))
                                    }
                                    .if(date.isSelected) {
                                        $0.clipShape(Circle())
                                    }
                                    .if(date.isToday) {
                                        $0.background(Color.blue)
                                    }
                                    .if(date.isToday) {
                                        $0.clipShape(Circle())
                                    }
                                    .opacity(date.disabled ? 0.2 : 1)
                                
                            }
                            .disabled(date.disabled)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .background(Color.blueGray)
                .cornerRadius(5)
                .padding(3)
                .background(Color.blueWhite)
                .cornerRadius(8)
                .padding(3)
                .onAppear{
                    viewModel.loadData(showAccesories: showAccesories, selectedDate: selectedDate, disablingDates: disablingAfterTodayDates)
                }
                Spacer()
            }
        }
    }
    
    func add(value: Int, using component: Calendar.Component) {
        if let safeDate = Calendar.current.date(byAdding: component, value: value, to: viewModel.firstDate)  {
            viewModel.firstDate = safeDate
            print(safeDate)
            viewModel.loadData(showAccesories: showAccesories, selectedDate: selectedDate, disablingDates: disablingAfterTodayDates)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(showAccesories: true, disablingAfterTodayDates: false, selectedDate: .constant(Date()))
    }
}
