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
                    Label("Start", systemImage: "house.fill")
                        .environment(\.symbolRenderingMode, .monochrome)
                }

            HistoryView(viewModel: viewModel)
                .tabItem {
                    Label("History", systemImage: "calendar")
                        .environment(\.symbolRenderingMode, .monochrome)
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                        .environment(\.symbolRenderingMode, .monochrome)
                }
        }
        .accentColor(Color(#colorLiteral(red: 0.7764705882, green: 0.3137254902, blue: 0.9686274510, alpha: 1)))
//        .background(
//            LinearGradient(
//                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6588235497, green: 0.5607843399, blue: 0.9764706349, alpha: 0.6)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 0.6))]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .edgesIgnoringSafeArea(.all)
//        )
    }
}

#Preview {
    ContentView()
}
