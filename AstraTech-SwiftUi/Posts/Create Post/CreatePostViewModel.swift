//
//  CreatePostViewModel.swift
//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 23/05/2025.

import SwiftUI

class CreatePostViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var posts: [Post] = []
    @Published var postCreated: Bool = false
    @Published var isCreating: Bool = false
    
    func createPost(title: String, content: String, image: UIImage?) {
        isLoading = true
        errorMessage = nil
                
        let newPost = ["title": title, "content": content]
        
        APIService.shared.postData(to: Apis.storeBlogs, body: newPost, image: image) { [weak self] (result: Result<Post, Error>) in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let post):
                    self?.posts.append(post)
                    self?.postCreated = true
                    NotificationCenter.default.post(name: NSNotification.Name("PostCreated"), object: nil)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
