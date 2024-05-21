//
//  ReadyTimerView.swift
//  PlankApp
//
//  Created by Ivan Trajanovski  on 21.05.24.
//

import SwiftUI

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


#Preview {
    ReadyTimerView()
}
