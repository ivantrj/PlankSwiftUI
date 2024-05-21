//
//  CountdownRingView.swift
//  PlankApp
//
//  Created by Ivan Trajanovski  on 21.05.24.
//

import SwiftUI

struct CountdownRingView: View {
    @ObservedObject var viewModel: PlankViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .foregroundColor(.white.opacity(0.3))
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(1 - (Double(viewModel.secondsRemaining) / Double(viewModel.initialDuration))))
                        .stroke(AngularGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7764705882, green: 0.3137254902, blue: 0.9686274510, alpha: 1)), Color(#colorLiteral(red: 0.9568627451, green: 0.2941176471, blue: 0.6588235294, alpha: 1)), Color(#colorLiteral(red: 0.7764705882, green: 0.3137254902, blue: 0.9686274510, alpha: 1))]), center: .center), style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
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


//#Preview {
//    CountdownRingView()
//}
