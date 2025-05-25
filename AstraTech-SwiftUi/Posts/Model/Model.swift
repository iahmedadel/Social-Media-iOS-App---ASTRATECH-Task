//
//  Model.swift
//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 22/05/2025.
//

import Foundation

struct Post: Codable, Identifiable, Hashable, Equatable {
    let id: Int
    let title: String
    let content: String
    let photo: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, photo
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension Post {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        let isoFormatter = DateFormatter()
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
        
        if let date = isoFormatter.date(from: createdAt) {
            return formatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
}
