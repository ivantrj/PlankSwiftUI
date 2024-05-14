//
//  PlankTabView.swift
//  PlankApp
//
//  Created by Ivan Trajanovski on 13.05.24.
//

import SwiftUI
import Combine

struct PlankTabView: View {
    @StateObject private var viewModel = PlankChallengeViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isPlankInProgress {
                PlankCountdownView(viewModel: viewModel)
            } else {
                Button(action: {
                    viewModel.startChallenge()
                }) {
                    Text("Start 30 day challenge day \(viewModel.currentDay)")
                }
            }
        }
        .onAppear {
            viewModel.updateCurrentDayIfNeeded()
        }
    }
}

struct PlankCountdownView: View {
    @ObservedObject var viewModel: PlankChallengeViewModel
    @State private var showConfetti: Bool = false
    
    var body: some View {
        VStack {
            if viewModel.secondsRemaining > 0 {
                Text("\(viewModel.secondsRemaining)")
                    .font(.largeTitle)
            } else {
                ConfettiView(isShowing: $showConfetti)
                    .onAppear {
                        showConfetti = true
                        viewModel.completeChallenge()
                    }
            }
        }
    }
}

struct ConfettiView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ConfettiCannon())
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
