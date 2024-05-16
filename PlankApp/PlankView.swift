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
    @State private var showingReadyTimer = false
    
    var body: some View {
        VStack {
            if viewModel.isPlankInProgress {
                PlankCountdownRingView(viewModel: viewModel)
            } else {
                Button(action: {
                    showingReadyTimer = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        viewModel.startChallenge()
                    }
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Start Plank Challenge")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Day \(viewModel.currentDay)/30")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right.circle.fill")
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $showingReadyTimer) {
                    ReadyTimerView()
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.updateCurrentDayIfNeeded()
        }
    }
}

struct ReadyTimerView: View {
    @State private var timeRemaining = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Text("Get Ready for Plank")
                .font(.title)
                .padding()
            
            Text("Time Remaining: \(timeRemaining)")
                .font(.largeTitle)
                .padding()
            
            Text("1. Lie face down on the floor, resting on your forearms and toes.\n2. Keep your body in a straight line from head to heels.\n3. Engage your core muscles by tightening your abdominal muscles.\n4. Hold this position until the countdown finishes.")
                .multilineTextAlignment(.center)
                .padding()
        }
        .onReceive(timer) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}

struct PlankCountdownRingView: View {
    @ObservedObject var viewModel: PlankViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        VStack {
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
            
            Button(action: {
                viewModel.cancelChallenge()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            })
            .padding()
        }
    }
}
