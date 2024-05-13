//
//  ConfettiCannon.swift
//  PlankApp
//
//  Created by Ivan Trajanovski on 13.05.24.
//

import SwiftUI

struct ConfettiCannon: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                ConfettiParticleView(particle: particle)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + particle.lifetime) {
                            withAnimation {
                                particles.removeAll { $0.id == particle.id }
                            }
                        }
                    }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                particles.append(ConfettiParticle())
            }
        }
    }
}

struct ConfettiParticleView: View {
    let particle: ConfettiParticle
    
    var body: some View {
        Image(systemName: "sparkle")
            .foregroundColor(particle.color)
            .offset(x: particle.x, y: particle.y)
            .rotationEffect(.degrees(particle.rotation))
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    let color: Color
    let x: CGFloat
    let y: CGFloat
    let rotation: Double
    let lifetime: TimeInterval
    
    init() {
        self.color = [.red, .green, .blue, .orange, .yellow].randomElement()!
        self.x = CGFloat.random(in: -100...100)
        self.y = CGFloat.random(in: -100...100)
        self.rotation = Double.random(in: 0...360)
        self.lifetime = Double.random(in: 2...4)
    }
}


#Preview {
    ConfettiCannon()
}
