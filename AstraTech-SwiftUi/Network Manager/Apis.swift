//
//  Apis.swift
//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel Pro on 22/05/2025.
//

import Foundation

enum Apis {
    static let baseUrl = "http://taskapi.astra-tech.net/api/blogs"
    static let storeBlogs = "\(baseUrl)/store"
    static func updateBlog(_ id: String) -> String { "\(baseUrl)/update/\(id)" }
    static func deleteBlog(_ id: String) -> String { "\(baseUrl)/delete/\(id)" }
}
