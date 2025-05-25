//
//  PostRowView.swift
//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 24/05/2025.
//

import SwiftUI

struct PostRowView: View {
    let post: Post
    @ObservedObject var viewModel: PostViewModel
    @State private var isHovered = false
    @State private var floatingHearts: [FloatingHeart] = []
    
    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                ZStack {
                    if !post.photo.isEmpty {
                        AsyncImage(url: URL(string: post.photo)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else if phase.error != nil {
                                Image(systemName: "photo.fill")
                                    .foregroundStyle(.gray)
                                    .frame(width: 100, height: 100)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } else {
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    } else {
                        Image(systemName: "photo.stack")
                            .foregroundStyle(.gray)
                            .frame(width: 100, height: 100)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(post.title)
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text(post.content.prefix(60) + (post.content.count > 60 ? "..." : ""))
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    
                    Button(action: {
                        viewModel.toggleLike(for: post.id)
                        if viewModel.likedPostIDs.contains(post.id) {
                            addFloatingHearts()
                        }
                    }) {
                        Image(systemName: viewModel.likedPostIDs.contains(post.id) ? "heart.fill" : "heart")
                            .foregroundStyle(viewModel.likedPostIDs.contains(post.id) ? .red : .gray)
                            .scaleEffect(viewModel.likedPostIDs.contains(post.id) ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: viewModel.likedPostIDs.contains(post.id))
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.gray)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "#686464"))
            )
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
            
            ForEach(floatingHearts) { heart in
                heart
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            floatingHearts.removeAll { $0.id == heart.id }
                        }
                    }
            }
        }
        
    }
    
    private func addFloatingHearts() {
        for _ in 0..<6 {
            floatingHearts.append(
                FloatingHeart(
                    id: UUID(),
                    startX: CGFloat.random(in: 100...300),
                    animationDuration: Double.random(in: 1.0...2.0),
                    color: .red
                )
            )
        }
    }
}

struct FloatingHeart: View, Identifiable {
    let id: UUID
    let startX: CGFloat
    let animationDuration: Double
    let color: Color
    @State private var offsetY: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(color)
            .position(x: startX, y: 100 + offsetY)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: animationDuration)) {
                    offsetY = -150
                    opacity = 0
                }
            }
    }
}
#Preview {
    PostRowView(
        post: Post(id: 1,title: "Sample Post", content: "This is a sample post content that is longer than 60 characters to test truncation.", photo: "https://example.com/image.jpg",createdAt: "2025-05-23T23:29:27.000000Z" , updatedAt: "2025-05-23T23:38:27.000000Z"),
        viewModel: PostViewModel()
    )
    
}
