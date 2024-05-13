//
//  PlankViewModel.swift
//  PlankApp
//
//  Created by Ivan Trajanovski on 13.05.24.
//

import Foundation
import Combine
import SwiftUI

import SwiftUI
import Combine

class PlankChallengeViewModel: ObservableObject {
    @Published var currentDay: Int = 1
    @Published var secondsRemaining: Int = 30
    @Published var isPlankInProgress: Bool = false
    @Published var history: [Bool] = Array(repeating: false, count: 30)
    
    var startDate: Date = Date() 
    
    var timer: Timer?
    var cancellable: AnyCancellable?
    
    init() {
        self.cancellable = $currentDay.sink { day in
            self.secondsRemaining = 30 + (day - 1) * 5
        }
    }
    
    func startPlankChallenge() {
        isPlankInProgress = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            } else {
                self.isPlankInProgress = false
                self.timer?.invalidate()
                self.history[self.currentDay - 1] = true
            }
        }
    }
    
    func updateCurrentDayIfNeeded() {
        let currentDate = Date()
        let calendar = Calendar.current
        if let days = calendar.dateComponents([.day], from: startDate, to: currentDate).day {
            if days >= 1 {
                currentDay += days
                startDate = currentDate
            }
        }
    }
}
