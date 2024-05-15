//
//  HistoryTabView.swift
//  PlankApp
//
//  Created by Ivan Trajanovski on 13.05.24.
//

import SwiftUI

struct HistoryTabView: View {
    @ObservedObject var viewModel: PlankChallengeViewModel
    @Environment(\.calendar) private var calendar

    private var weekdaySymbols: [String] {
        return calendar.veryShortWeekdaySymbols
    }

    private let daysInMonth: [Int] = Array(1...31)

    private var startDate: Date {
        let components = DateComponents(year: 2023, month: 5, day: 1)
        return calendar.date(from: components) ?? Date()
    }

    var body: some View {
        VStack {
            Text("History")
                .font(.title)
                .padding()

            Spacer()

            ScrollView {
                VStack(spacing: 8) {
                    HStack {
                        ForEach(weekdaySymbols, id: \.self) { symbol in
                            Text(symbol)
                                .frame(maxWidth: .infinity)
                        }
                    }

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                        ForEach(daysInMonth, id: \.self) { day in
                            let dayIndex = viewModel.history.count - (31 - day) - 1
                            let isCompleted = dayIndex >= 0 && dayIndex < viewModel.history.count && viewModel.history[dayIndex]

                            DayView(day: day, isCompleted: isCompleted)
                        }
                    }
                }
                .padding()
            }
        }
    }

    struct DayView: View {
        let day: Int
        let isCompleted: Bool

        var body: some View {
            Text("\(day)")
                .frame(width: 30, height: 30)
                .background(isCompleted ? Color.green : Color.secondary.opacity(0.3))
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
}
