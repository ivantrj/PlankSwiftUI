//
//  ContentView.swift
//  PlankApp
//
//  Created by Ivan Trajanovski on 13.05.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PlankViewModel()
    
    var body: some View {
        TabView {
            PlankView()
                .tabItem {
                    Label("Plank", systemImage: "square.and.arrow.up")
                }
            HistoryView(viewModel: viewModel)
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
