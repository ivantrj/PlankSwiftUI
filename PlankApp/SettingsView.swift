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
    @StateObject private var viewModel = PlankViewModel()
    @State private var showingResetConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    Toggle("Voice Guidance", isOn: $isVoiceEnabled)
                        .tint(.accentColor)
                    
                    Toggle("Haptic Feedback", isOn: $isHapticFeedbackEnabled)
                        .tint(.accentColor)
                }
                
                Section(header: Text("Challenge")) {
                    Button(action: {
                        showingResetConfirmation = true
                    }) {
                        Text("Reset Challenge")
                            .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("About")) {
                    Button("About the Author") {
                        showingAboutAuthor.toggle()
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingAboutAuthor) {
                AboutAuthorView()
            }
            .alert("Reset Challenge", isPresented: $showingResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    viewModel.resetChallenge()
                }
            } message: {
                Text("Are you sure you want to reset the challenge? This will set the current day back to 1.")
            }
        }
    }
}

#Preview {
    SettingsView()
}
