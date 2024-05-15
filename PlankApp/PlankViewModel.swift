//
//  PlankViewModel.swift
//  PlankApp
//
//  Created by Ivan Trajanovski on 13.05.24.
//

import Foundation
import Combine
import SwiftUI

class PlankViewModel: ObservableObject {
    @Published var currentDay: Int = 1
    @Published var secondsRemaining: Int = 30
    @Published var isPlankInProgress: Bool = false
    @Published private(set) var history: [Bool] = []
    @Published var initialDuration: Int = 30 // Initial duration in seconds
    
    private var startDate: Date = Date()
    private var timer: Timer?
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = $currentDay
            .sink { [weak self] day in
                guard let self = self else { return }
                self.initialDuration = 30 + (day - 1) * 5
                self.secondsRemaining = self.initialDuration
            }
    }
    
    func startChallenge() {
        isPlankInProgress = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.secondsRemaining > 0 {
                self.secondsRemaining -= 1
            } else {
                self.completeChallenge()
            }
        }
    }
    
    func completeChallenge() {
        isPlankInProgress = false
        timer?.invalidate()
        timer = nil
        history.append(true)
        currentDay = min(currentDay + 1, 30)
    }
    
    func cancelChallenge() {
        isPlankInProgress = false
        timer?.invalidate()
        timer = nil
    }
    
    func updateTimer() {
        if isPlankInProgress && secondsRemaining > 0 {
            secondsRemaining -= 1
            if secondsRemaining == 0 {
                completeChallenge()
            }
        }
    }
    
    func updateCurrentDayIfNeeded() {
        let currentDate = Date()
        let calendar = Calendar.current
        if let days = calendar.dateComponents([.day], from: startDate, to: currentDate).day,
           days > 0 {
            currentDay = min(currentDay + days, 30)
            startDate = currentDate
            history = Array(repeating: false, count: currentDay - 1)
        }
    }
}
