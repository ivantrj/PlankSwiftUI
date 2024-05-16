//
//  SettingsView.swift
//  PlankApp
//
//  Created by Ivan Trajanovski on 13.05.24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isVoiceEnabled") private var isVoiceEnabled = false
    @AppStorage("isHapticFeedbackEnabled") private var isHapticFeedbackEnabled = true
    @State private var showingAboutAuthor = false
    //    @AppStorage("challengeDuration") private var challengeDuration = 30
    //    @AppStorage("reminderTime") private var reminderTime = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Voice Guidance", isOn: $isVoiceEnabled)
                        .tint(.accentColor)
                    Toggle("Haptic Feedback", isOn: $isHapticFeedbackEnabled)
                        .tint(.accentColor)
                }
                
                Section(header: Text("About")) {
                    Button("About the Author") {
                        showingAboutAuthor.toggle()
                    }
                }
                
                //                Section(header: Text("Challenge")) {
                //                    Stepper("Challenge Duration (Days): \(challengeDuration)", value: $challengeDuration, in: 7...90, step: 1)
                
                //                    DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                //                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingAboutAuthor) {
                AboutAuthorView()
            }
        }
    }
}

#Preview {
    SettingsView()
}
