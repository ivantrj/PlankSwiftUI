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
    @State private var animateButton = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6588235497, green: 0.5607843399, blue: 0.9764706349, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.top)


            VStack(spacing: 20) {
                if viewModel.isPlankInProgress {
                    PlankCountdownRingView(viewModel: viewModel)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Plank Challenge")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Day \(viewModel.currentDay)/30")
                            .font(.title2)
                            .foregroundColor(.white)

                        Button(action: {
                            showingReadyTimer = true
                            animateButton = true

                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                viewModel.startChallenge()
                            }
                        }) {
                            Text("Start Plank")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(
                                    Capsule()
                                        .fill(Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)))
                                        .shadow(radius: 5)
                                        .scaleEffect(animateButton ? 1.1 : 1.0)
                                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: animateButton)
                                )
                        }
                    }
                    .padding()
                }
            }
            .padding()
            .sheet(isPresented: $showingReadyTimer) {
                ReadyTimerView()
            }
            .onAppear {
                viewModel.updateCurrentDayIfNeeded()
            }
        }
    }
}

struct ReadyTimerView: View {
    @State private var timeRemaining = 5
    @State private var isAnimating = false
    @Environment(\.presentationMode) var presentationMode
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6588235497, green: 0.5607843399, blue: 0.9764706349, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Get Ready for Plank")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(timeRemaining.formatted())
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isAnimating)
                
                Text("🧘‍♀️ Get into position 🧘‍♂️")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                
                Text("1. Lie face down on the floor, resting on your forearms and toes.\n\n2. Keep your body in a straight line from head to heels.\n\n3. Engage your core muscles by tightening your abdominal muscles.\n\n4. Hold this position until the countdown finishes.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
            }
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                    isAnimating = true
                } else {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .onAppear {
                isAnimating = true
            }
            .onDisappear {
                timer.upstream.connect().cancel()
            }
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
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6588235497, green: 0.5607843399, blue: 0.9764706349, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .foregroundColor(.white.opacity(0.3))
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(1 - (Double(viewModel.secondsRemaining) / Double(viewModel.initialDuration))))
                        .stroke(AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7764705882, green: 0.3137254902, blue: 0.9686274510, alpha: 1)), Color(#colorLiteral(red: 0.9568627451, green: 0.2941176471, blue: 0.6588235294, alpha: 1))]), center: .center, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 450)), style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                        .rotationEffect(Angle(degrees: 270))
                        .animation(.easeInOut(duration: 1.0), value: viewModel.secondsRemaining)
                    
                    Text("\(viewModel.secondsRemaining)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
                .frame(width: 250, height: 250)
                .padding()
                
                if viewModel.secondsRemaining <= 0 {
                    Button(action: {
                        viewModel.completeChallenge()
                    }) {
                        Text("Complete Challenge")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(
                                Capsule()
                                    .fill(Color.green)
                                    .shadow(radius: 5)
                            )
                    }
                }
                
                Button(action: {
                    viewModel.cancelChallenge()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(
                            Capsule()
                                .fill(Color.red)
                                .shadow(radius: 5)
                        )
                }
            }
            .onReceive(timer) { _ in
                if viewModel.isPlankInProgress {
                    viewModel.updateTimer()
                }
            }
        }
    }
}
