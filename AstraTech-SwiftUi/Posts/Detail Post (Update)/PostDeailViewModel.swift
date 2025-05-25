//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel Pro on 22/05/2025.
//
import Foundation
import SwiftUI

class PostDeailViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedPost: Post? = nil
    @Published var shouldDismiss: Bool = false
    
    var viewModel = PostViewModel()
    
    func updatePost(_ post: Post, image: UIImage? = nil) {
        isLoading = true
        errorMessage = nil
                
        if image == nil && !post.photo.isEmpty {
            fetchImage(from: post.photo) { [weak self] fetchedImage in
                guard let self = self else { return }
                let updateData = ["title": post.title, "content": post.content, "photo": post.photo]
                
                APIService.shared.postData(to: Apis.updateBlog("\(post.id)"), body: updateData, image: fetchedImage, method: "POST") { [weak self] (result: Result<Post, Error>) in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        switch result {
                        case .success(let response):
                            if let index = self?.posts.firstIndex(where: { $0.id == post.id }) {
                                self?.posts[index] = post
                            }
                            self?.selectedPost = nil
                            self?.shouldDismiss = true
                        case .failure(let error):
                            self?.errorMessage = error.localizedDescription
                        }
                    }
                }
            }
        } else {
            
            let updateData = ["title": post.title, "content": post.content, "photo": post.photo]
            
            APIService.shared.postData(to: Apis.updateBlog("\(post.id)"), body: updateData, image: image, method: "POST") { [weak self] (result: Result<Post, Error>) in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success:
                        if let index = self?.posts.firstIndex(where: { $0.id == post.id }) {
                            self?.posts[index] = post
                        }
                        self?.selectedPost = nil
                        self?.shouldDismiss = true
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    private func fetchImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    func deletePost(_ post: Post) {
        isLoading = true
        errorMessage = nil
        

        guard let url = URL(string: Apis.deleteBlog("\(post.id)")) else {
            self.errorMessage = "Invalid delete URL"
            self.isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Delete failed: \(error.localizedDescription)"
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                        self?.posts.removeAll { $0.id == post.id }
                        self?.viewModel.posts.removeAll { $0.id == post.id }
                        self?.selectedPost = nil
                    } else {
                        self?.errorMessage = "Server error: Status code \(httpResponse.statusCode)"
                    }
                }
            }
        }.resume()
    }
}
