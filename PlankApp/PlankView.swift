//
//  PlankTabView.swift
//  PlankApp
//
//  Created by Ivan Trajanovski on 13.05.24.
//

import SwiftUI
import Combine

struct PlankView: View {
    @StateObject private var viewModel = PlankViewModel()

    var body: some View {
        VStack {
            if viewModel.isPlankInProgress {
                PlankCountdownRingView(viewModel: viewModel)
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

struct PlankCountdownRingView: View {
    @ObservedObject var viewModel: PlankViewModel
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            // Placeholder Ring
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
                .opacity(0.1)
            
            // Colored Ring
            Circle()
                .trim(from: 0.0, to: CGFloat(1 - (Double(viewModel.secondsRemaining) / Double(viewModel.initialDuration))))
                .stroke(AngularGradient(gradient: Gradient(colors: [Color.purple, Color.pink, Color.purple]), center: .center), style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: viewModel.secondsRemaining)
            
            VStack(spacing: 30) {
                Text("\(viewModel.secondsRemaining)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if viewModel.secondsRemaining <= 0 {
                    Button(action: {
                        viewModel.completeChallenge()
                    }) {
                        Text("Complete Challenge")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .frame(width: 300, height: 300)
        .padding()
        .onReceive(timer) { _ in
            if viewModel.isPlankInProgress {
                viewModel.updateTimer()
            }
        }
    }
}
