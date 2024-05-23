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
    @Published var currentDay: Int = 1 {
        didSet {
            saveCurrentDay()
        }
    }
    @Published var secondsRemaining: Int = 30
    @Published var isPlankInProgress: Bool = false
    @Published private(set) var history: [Bool] = [] {
        didSet {
            saveHistory()
        }
    }
    @Published var initialDuration: Int = 30 {
        didSet {
            saveInitialDuration()
        }
    }
    
    private var startDate: Date = Date()
    private var timer: Timer?
    private var cancellable: AnyCancellable?
    
    private let userDefaults = UserDefaults.standard
    private let currentDayKey = "CurrentDay"
    private let historyKey = "History"
    private let initialDurationKey = "InitialDuration"
    
    init() {
        cancellable = $currentDay
            .sink { [weak self] day in
                guard let self = self else { return }
                self.initialDuration = 30 + (day - 1) * 5
                self.secondsRemaining = self.initialDuration
            }
        
        loadCurrentDay()
        loadHistory()
        loadInitialDuration()
    }
    
    func startChallenge(with assessedTime: Int? = nil) {
        isPlankInProgress = true
        
        if let assessedTime = assessedTime {
            initialDuration = assessedTime
        }
        
        secondsRemaining = initialDuration
        
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
    
    private func saveCurrentDay() {
        userDefaults.set(currentDay, forKey: currentDayKey)
    }
    
    private func loadCurrentDay() {
        if let savedCurrentDay = userDefaults.object(forKey: currentDayKey) as? Int {
            currentDay = savedCurrentDay
        }
    }
    
    private func saveHistory() {
        userDefaults.set(history, forKey: historyKey)
    }
    
    private func loadHistory() {
        if let savedHistory = userDefaults.object(forKey: historyKey) as? [Bool] {
            history = savedHistory
        }
    }
    
    private func saveInitialDuration() {
        userDefaults.set(initialDuration, forKey: initialDurationKey)
    }
    
    private func loadInitialDuration() {
        if let savedInitialDuration = userDefaults.object(forKey: initialDurationKey) as? Int {
            initialDuration = savedInitialDuration
        }
    }
    
    func resetChallenge() {
        currentDay = 1
        history = []
        saveCurrentDay()
        saveHistory()
        loadHistory()
    }
}
