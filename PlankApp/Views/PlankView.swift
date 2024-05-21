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
                                viewModel.startChallenge()
                            }
                        }) {
                            Text("Start Plank")
                    a            .font(.title2)
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

