//
//  HistoryTabView.swift
//  PlankApp
//
//  Created by Ivan Trajanovski on 13.05.24.
//

import SwiftUI


struct HistoryTabView: View {
    @ObservedObject var viewModel: PlankChallengeViewModel
    
    var body: some View {
        VStack {
            Text("History")
            Spacer()
            ScrollView {
                VStack {
                    ForEach(0..<viewModel.history.count, id: \.self) { index in
                        HStack {
                            Text("Day \(index + 1)")
                            Spacer()
                            Image(systemName: viewModel.history[index] ? "checkmark.circle.fill" : "circle")
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    HistoryTabView()
//}
