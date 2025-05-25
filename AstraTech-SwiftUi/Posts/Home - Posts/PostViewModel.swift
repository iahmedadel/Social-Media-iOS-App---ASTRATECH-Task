//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 23/05/2025.

import SwiftUI

// MARK: - View Models
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""
    @Published var selectedTab: String = "all"
    @Published var likedPostIDs: Set<Int> = []
    
    init() {
        if let savedLikes = UserDefaults.standard.array(forKey: "likedPostIDs") as? [Int] {
            likedPostIDs = Set(savedLikes)
        }
    }
    
    var filteredPosts: [Post] {
        var filtered: [Post]
        
        switch selectedTab {
        case "liked":
            filtered = posts.filter { likedPostIDs.contains($0.id) }
        case "latest":
            filtered = posts.sorted { post1, post2 in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
                guard let date1 = formatter.date(from: post1.createdAt),
                      let date2 = formatter.date(from: post2.createdAt) else {
                    return false
                }
                return date1 > date2
            }
        case "all":
            filtered = posts
        default:
            filtered = posts
        }
        
        if !searchQuery.isEmpty {
            filtered = filtered.filter { $0.title.lowercased().contains(searchQuery.lowercased()) }
        }
        
        return filtered
    }
    
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        guard let url = URL(string: Apis.baseUrl) else {
            completion(nil)
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error?.localizedDescription
                    completion(nil)
                }
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.posts = posts
                    completion(posts)
                }
            } catch {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                    completion(nil)
                }
            }
        }.resume()
    }
    
    func toggleLike(for postID: Int) {
        if likedPostIDs.contains(postID) {
            likedPostIDs.remove(postID)
        } else {
            likedPostIDs.insert(postID)
        }
        UserDefaults.standard.set(Array(likedPostIDs), forKey: "likedPostIDs")
    }
}

