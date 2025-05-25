//
//  MainContentView.swift
//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 24/05/2025.
//

import SwiftUI

struct MainContentView: View {
    @ObservedObject var showPostsViewModel: PostViewModel
    @ObservedObject var createPostViewModel: CreatePostViewModel
    @ObservedObject var detailViewModel: PostDeailViewModel 
    @Binding var scale: CGFloat
    @Binding var navigateToCreatePost: Bool

    var body: some View {
        VStack {
            Picker("View", selection: $showPostsViewModel.selectedTab) {
                Text("All").tag("all")
                Text("Latest").tag("latest")
                Text("Liked").tag("liked")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top)
            ZStack {
                PostsListView(viewModel: showPostsViewModel, DetailViewModel: detailViewModel)
                    .navigationTitle("Home")
                
                
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            
                            PlusButtonView(scale: $scale, action: {
                                navigateToCreatePost = true
                            })
                            
                        }
                    }
                
                    .searchable(text: $showPostsViewModel.searchQuery, prompt: "Search Posts by title")
                    .refreshable {
                        showPostsViewModel.fetchPosts { _ in
                        }
                    }
                    .onAppear {
                        Task {
                            showPostsViewModel.fetchPosts { _ in
                            }
                        }
                        
                    }
                    .navigationDestination(item: $detailViewModel.selectedPost) { post in
                        PostDetailView(post: post, viewModel: detailViewModel)
                    }
                
                    .navigationDestination(isPresented: $navigateToCreatePost) {
                        CreatePostView(viewModel: createPostViewModel)
                    }
                
                EmptyStateView(viewModel: showPostsViewModel)
                
                
            }
        }
    }
}


#Preview {
    MainContentView(
            showPostsViewModel: PostViewModel(),
            createPostViewModel: CreatePostViewModel(),
            detailViewModel: PostDeailViewModel(),
            scale: .constant(1.0),
            navigateToCreatePost: .constant(false)
        )
}
