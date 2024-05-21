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
    @State private var showAssessment = false
    @State private var assessedTime: Int?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.top)
            
            
            VStack(spacing: 20) {
                if viewModel.isPlankInProgress {
                    CountdownRingView(viewModel: viewModel)
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
                                viewModel.startChallenge(with: assessedTime)
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
                        
                        Button(action: {
                            showAssessment = true
                        }) {
                            Text("Take Assessment")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 15)
                                .background(
                                    Capsule()
                                        .fill(Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)))
                                        .shadow(radius: 5)
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
            .sheet(isPresented: $showAssessment) {
                AssessmentView(assessedTime: $assessedTime)
            }
            .onAppear {
                viewModel.updateCurrentDayIfNeeded()
            }
        }
    }
}

struct AssessmentView: View {
    @State private var timer: Timer?
    @State private var elapsedTime = 0
    @Binding var assessedTime: Int?
    @Environment(\.presentationMode) var presentationMode

    @State private var isAnimating = false
    
    let timer1 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6588235497, green: 0.5607843399, blue: 0.9764706349, alpha: 1)), Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Assess Your Plank Time")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(elapsedTime.formatted())
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isAnimating)
                
                Text("Hold the plank position for as long as you can")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                
                Button(action: {
                    if timer == nil {
                        startTimer()
                    } else {
                        stopTimer()
                    }
                }) {
                    Text(timer == nil ? "Start" : "Stop")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Capsule()
                                .fill(Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)))
                                .shadow(radius: 5)
                        )
                }
                
                Button(action: {
                    assessedTime = elapsedTime
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Use this time as baseline")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Capsule()
                                .fill(Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)))
                                .shadow(radius: 5)
                        )
                }
            }
            .onReceive(timer1) { _ in
                if timer != nil {
                    elapsedTime += 1
                }
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
