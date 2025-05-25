//
//  LoadingView.swift
//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 23/05/2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.blue, .purple, .blue]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 50, height: 50)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                
                Text("Loading...")
                    .font(.system(.headline, design: .rounded, weight: .medium))
                    .foregroundStyle(.white)
            }
            .padding(30)
            .background(Color(.systemGray6).opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.3), radius: 10)
        }
        .onAppear {
            isAnimating = true
        }
    }
    
}

#Preview {
    LoadingView()
}
