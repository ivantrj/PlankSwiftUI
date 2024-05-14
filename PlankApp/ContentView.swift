//
//  ContentView.swift
//  PlankApp
//
//  Created by Ivan Trajanovski on 13.05.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PlankChallengeViewModel()
    
    var body: some View {
        TabView {
            PlankTabView()
                .tabItem {
                    Label("Plank", systemImage: "square.and.arrow.up")
                }
            HistoryTabView(viewModel: viewModel)
                .tabItem {
                    Label("History", systemImage: "calendar")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
