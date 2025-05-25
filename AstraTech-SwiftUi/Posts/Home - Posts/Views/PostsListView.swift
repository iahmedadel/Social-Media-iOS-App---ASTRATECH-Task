//
//  PostsListView.swift
//  AstraTech-SwiftUi
//
//  Created by MacBook Pro on 24/05/2025.
//

import SwiftUI


struct PostsListView: View {
    @ObservedObject var viewModel: PostViewModel
    @ObservedObject var DetailViewModel: PostDeailViewModel // Fixed typo

    var body: some View {
        List {
            ForEach(viewModel.filteredPosts) { post in
                PostRowView(post: post, viewModel: viewModel)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        DetailViewModel.selectedPost = post
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
//        .background(
//            LinearGradient(
//                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
    }
}

#Preview {
    PostsListView(viewModel: PostViewModel(), DetailViewModel: PostDeailViewModel())
}
