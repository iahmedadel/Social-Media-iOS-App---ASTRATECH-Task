//
//  EmptyStateView.swift
//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 24/05/2025.
//

import SwiftUI


struct EmptyStateView: View {
    @ObservedObject var viewModel: PostViewModel

    var body: some View {
        if viewModel.filteredPosts.isEmpty && !viewModel.isLoading {
            VStack(spacing: 16) {
                Image(systemName: viewModel.searchQuery.isEmpty ? "photo.stack" : "magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundStyle(.gray)
                    .opacity(0.7)
                Text(viewModel.searchQuery.isEmpty ? "No Posts" : "No Results")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Text(viewModel.searchQuery.isEmpty ? "Tap the + button to share a post with Your Friends" : "No Posts match your search")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
    }
}


#Preview {
    EmptyStateView(viewModel: PostViewModel())
}
